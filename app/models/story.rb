class Story < ActiveRecord::Base
  has_attached_file :picture
  
  validates_presence_of :name, :copy
  
  def self.random
    ids = connection.select_all("SELECT id FROM stories WHERE active = true")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
end
