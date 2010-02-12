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

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Search.new.valid?
  end
end
