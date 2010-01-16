class Search < ActiveRecord::Base
  validates_presence_of :from_user, :status_id, :message
  validates_uniqueness_of :from_user
  
  belongs_to :user
  
end
