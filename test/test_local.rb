require "helper"

class TestPaperclipLocal < Test::Unit::TestCase
  context "SimpleWorker-Paperclip locally" do
    setup do
      # Setup SimpleWorker
      # Setup the model
      # Setup an instance
    end
    should "be marked for processing" do
      assert_equal @dummy.image.url =~ /missing/, true
    end
  end
end
