class DirectMessage < ActiveRecord::Base
  belongs_to :tweet
  validates_presence_of :name, :message
  
  def self.random
    ids = connection.select_all("SELECT id FROM direct_messages WHERE active = true")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
end
