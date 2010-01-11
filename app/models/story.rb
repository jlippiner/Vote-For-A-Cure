class Story < ActiveRecord::Base
  attr_accessible :name, :copy, :active, :picture_file_name, :picture_content_type, :picture_file_size, :picture_updated_at
end
