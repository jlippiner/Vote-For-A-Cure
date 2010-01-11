# == Schema Information
#
# Table name: statuses
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  message    :string(255)
#  active     :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class Status < ActiveRecord::Base
  belongs_to :tweet

  validates_presence_of :name, :message
  validates_length_of :message, :within => 1..144

  def self.random
    ids = connection.select_all("SELECT id FROM statuses WHERE active = true")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
end
