# The action-man file

require "active_support/core_ext"
require "paperclip"

require "simple_worker/paperclip/base"
require "simple_worker/paperclip/activerecord"
require "simple_worker/paperclip/worker"

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, SimpleWorker::Paperclip::ActiveRecordHijack)
end
