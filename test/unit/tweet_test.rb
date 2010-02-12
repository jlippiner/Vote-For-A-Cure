# == Schema Information
#
# Table name: tweets
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  send_dm           :boolean(1)      default(TRUE)
#  follow_us         :boolean(1)      default(TRUE)
#  completed         :boolean(1)      default(FALSE)
#  status_id         :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  direct_message_id :integer(4)
#  allow_replies     :boolean(1)      default(TRUE)
#

require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Tweet.new.valid?
  end
end

