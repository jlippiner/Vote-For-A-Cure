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

require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Story.new.valid?
  end
end
