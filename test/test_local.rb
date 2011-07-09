require "helper"

class TestPaperclipLocal < Test::Unit::TestCase
  context "SimpleWorker-Paperclip locally" do
    setup do
      # Setup SimpleWorker
      SimpleWorker.configure do |c|
        c.access_key = ENV['SW_ACCESS']; c.secret_key = ENV['SW_SECRET']
        c.arbitrary = {:paperclip => true}
        c.auto_merge = true
      end
      # Setup the model
      require "paperclip_model"
      # Setup an instance
    end
    should "be marked for processing" do
      assert_equal @dummy.image.url =~ /missing/, true
    end
  end
end
