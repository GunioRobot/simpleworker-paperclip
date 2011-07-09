# Extending the SimpleWorker Gem
module SimpleWorker
  module Paperclip
    # Class for de-facto's, such as checking for configuration
    class Base
      # For reading the result of self.configured? should it get lost
      attr_reader :configured
      # Method for checking if SimpleWorker has been properly configured to run Paperclip in the cloud
      # @param [Boolean] stfu - true if you don't want it to raise an exception on misconfiguration
      # @return [Boolean] if it's configured correctly
      def self.configured?(stfu = false)
       @configured = SimpleWorker.config.auto_merge == true
       @configured = @configured && SimpleWorker.config.database.is_a?(Hash)
       @configured = @configured && SimpleWorker.config.arbitary[:paperclip] == true
       if @configured == false
         raise SimpleWorker::Paperclip::ConfigurationError unless stfu == true
         return false
       else
         # Chock's away Pippin!
         return true
       end
      end
    end
  end
end
