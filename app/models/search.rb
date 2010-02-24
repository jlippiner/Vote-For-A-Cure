# == Schema Information
#
# Table name: searches
#
#  id           :integer(4)      not null, primary key
#  status_id    :string(255)
#  from_user    :string(255)
#  from_user_id :string(255)
#  message      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer(4)
#  in_process   :boolean(1)      default(FALSE)
#  posted_at    :datetime
#  tag          :string(255)
#

class Search < ActiveRecord::Base
  validates_presence_of :from_user, :status_id, :message
  validates_uniqueness_of :from_user, :scope => :tag 

  belongs_to :user
  named_scope :available, :conditions => "user_id IS NULL AND in_process IS NOT TRUE"
  named_scope :by_tag, lambda { |tag| { :conditions => ['tag = ?', tag] } }
  
end
