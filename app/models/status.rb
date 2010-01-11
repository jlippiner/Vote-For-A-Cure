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
end

