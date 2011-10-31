# The business end of things
module SimpleWorker::Paperclip
  # This is the section cleanroomed from https://github.com/jstorimer/delayed_paperclip/blob/master/lib/delayed/paperclip.rb
  # LICENSE.txt has been modified accordingly
  # This module is included into ActiveRecord::Base if it exists
  module ActiveRecordHijack
    # I have no idea what this does :/
    def self.included?(base)
      base.extend(ClassMethods)
    end

    # Contains methods for adding to Paperclip
    module ClassMethods
      # Magic def which tells simpleworker-paperclip to process this model
      def process_with_simpleworker(name, opts = {})
        include InstanceMethods

        priority = opts.key?(:priority) ? options[:priority] : 0

        define_method "#{name}_changed?" do
          attachment_has_changed?(name)
        end

        define_method "halt_processing_for_#{name}" do
          return unless self.send("#{name}_changed?")

          false # halts processing
        end

        define_method "enqueue_job_for_#{name}" do
          return unless self.send("#{name}_changed?")

          # Paperclip::Attachment#queue_existing_for_delete sets paperclip
          # attributes to nil when the record has been marked for deletion
          return if self.class::PAPERCLIP_ATTRIBUTES.map { |suff| self.send "#{name}#{suff}" }.compact.empty?

          # ENQUEUE THE JOB HERE
          # LIEK NAOW
          @j = SimpleWorkerPaperclipJob.new(:klass => self.class.name, :id => self.id, :name => name.to_s)
          @j.queue
        end

        define_method "#{name}_processed!" do
          return unless column_exists?(:"#{name}_processing")
          return unless self.send(:"#{name}_processing?")

          self.send("#{name}_processing=", false)
          self.save(:validate => false)
        end

        define_method "#{name}_processing!" do
          return unless column_exists?(:"#{name}_processing")
          return if self.send(:"#{name}_processing?")
          return unless self.send(:"#{name}_changed?")

          self.send("#{name}_processing=", true)
        end

        self.send("before_#{name}_post_process", :"halt_processing_for_#{name}")

        before_save :"#{name}_processing!"
        after_save  :"enqueue_job_for_#{name}"
      end
    end


    # Methods for the instance, not for the class...
    module InstanceMethods
      # Paperclip-specific attributes, usually added by the migration
      PAPERCLIP_ATTRIBUTES = ['_file_size', '_file_name', '_content_type', '_updated_at']
      # Used to tell if an attachment has been modified by it's attributes

      def attachment_has_changed?(name)
        PAPERCLIP_ATTRIBUTES.each do |attribute|
          full_attribute = "#{name}#{attribute}_changed?".to_sym

          next unless self.respond_to?(full_attribute)
          return true if self.send("#{name}#{attribute}_changed?")
        end

        false
      end

      # Used to check if a specifc column on a Paperclip model exists and returns the result
      def column_exists?(column)
        self.class.columns_hash.has_key?(column.to_s)
      end
    end
  end
end

# Extending Paperclip with Paperclip::Attachment
module Paperclip
  # Extending Paperclip::Attachment
  class Attachment
    # Used to tell if this particular attachment is currently processing - set and read by worker code
    attr_accessor :job_is_processing

    # Fancy def for getting the url of a processed mat
    def url_with_processed(style = default_style, include_updated_timestamp = @use_timestamp)
      return url_without_processed style, include_updated_timestamp unless @instance.respond_to?(:column_exists?)
      return url_without_processed style, include_updated_timestamp if job_is_processing

      if !@instance.column_exists?(:"#{@name}_processing")
        url_without_processed style, include_updated_timestamp
      else
        if !@instance.send(:"#{@name}_processing?")
          url_without_processed style, include_updated_timestamp
        else
          if @instance.send(:"#{@name}_changed?")
            url_without_processed style, include_updated_timestamp
          else
            interpolate(@default_url, style)
          end
        end
      end
    end

    alias_method_chain :url, :processed
  end
end
