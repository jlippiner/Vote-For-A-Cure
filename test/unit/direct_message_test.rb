# == Schema Information
#
# Table name: direct_messages
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  message    :string(255)
#  active     :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class DirectMessageTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert DirectMessage.new.valid?
  end
end
