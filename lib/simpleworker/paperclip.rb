# The action-man file
require "simpleworker/paperclip/base"
require "simpleworker/paperclip/activerecord"
require "simpleworker/paperclip/worker"

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, SimpleWorker::Paperclip::ActiveRecordHijack)
end
