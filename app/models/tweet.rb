# == Schema Information
#
# Table name: tweets
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  send_dm    :boolean(1)      default(TRUE)
#  follow_us  :boolean(1)      default(TRUE)
#  completed  :boolean(1)      default(FALSE)
#  status_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :status
  belongs_to :direct_message
  
  before_create :add_status_and_direct_message
  
  private
  
  def add_status_and_direct_message
    self.direct_message = DirectMessage.random
  end

end