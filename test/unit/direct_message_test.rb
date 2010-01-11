require 'test_helper'

class DirectMessageTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert DirectMessage.new.valid?
  end
end
