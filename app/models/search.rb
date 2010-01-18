class Search < ActiveRecord::Base
  validates_presence_of :from_user, :status_id, :message
  validates_uniqueness_of :from_user

  belongs_to :user
  named_scope :available, :conditions => "user_id IS NULL AND in_process IS NOT TRUE"
end
