# == Schema Information
#
# Table name: stories
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  copy                 :string(255)
#  active               :boolean(1)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class Story < ActiveRecord::Base
  has_attached_file :picture
  
  validates_presence_of :name, :copy
  
  def self.random
    ids = connection.select_all("SELECT id FROM stories WHERE active = true")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
end
