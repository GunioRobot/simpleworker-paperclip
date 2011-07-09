# Extending the SimpleWorker Gem
module SimpleWorker
  module Paperclip
    # Class for de-facto's, such as checking for configuration
    class Base
      # Method for checking if SimpleWorker has been properly configured to run Paperclip in the cloud
      # @returns true
      def self.configured?
        SimpleWorker.config.auto_merge == true && SimpleWorker.config.database.is_a?(Hash) && SimpleWorker.config.arbitary[:paperclip] == true
      end
    end
  end
end
