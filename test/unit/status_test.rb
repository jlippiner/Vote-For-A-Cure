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

require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Status.new.valid?
  end
end

