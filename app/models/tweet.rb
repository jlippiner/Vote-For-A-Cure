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

class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :status
  belongs_to :direct_message
  has_many :searches, :through => :user 
  
  named_scope :to_reply, :conditions => ['allow_replies = ? AND user_id IS NOT NULL', true]
  
  before_create :add_status_and_direct_message
  
  private
  
  def add_status_and_direct_message
    self.direct_message = DirectMessage.random
  end
  
  def self.without_searches
    self.to_reply.select {|x| x.searches.empty?}
  end

  def self.with_searches
    self.to_reply.select {|x| !x.searches.empty?}
  end
end
