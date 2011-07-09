module SimpleWorker::Paperclip
  class Worker < SimpleWorker::Base
 
    ##
    #  Merge in the two absolutely required gem's
    #  The rest should be taken in via config.auto_merge
    #
    merge_gem "simpleworker-paperclip"
    merge_gem "paperclip"

    ##
    #  Accessors for handling job data of the item which requires processing
    #
    attr_accessor :instance_klass, :instance_id, :attachment_name


    ##
    #  #initialize - sets accessors from a hash for less LOC config
    #  @params [Hash, items] Location for item to be processed 
    def initialize(items = {})
      # Get accessors out of hash
      @instance_klass = items[:klass]
      @instance_id    = items[:id]
      @attacment_name = items[:name]
    end

    # Executed in SimpleWorker Cloud and with #run_local
    def run
      # Get the proper attachment_name from #to_sym
      @attachment_name = @attachment_name.to_sym
      # Contantize @instance_klass
      # And get the instance for @instance_id
      # Sling it into the process_job block
      process_job(@instance, @attachment_name) do
        # Act the fool
        @instance.send(@attachment_name).reprocess!
        @instance.send("#{@attachment_name}_processed!")
      end
    end

    private
    ##
    # Marks task as processing
    def process_job(instance, attachment_name)
      instance.send(attachment_name).job_is_processing = true
      yield
      instance.send(attachment_name).job_is_processing = false
    end

  end
end

      
