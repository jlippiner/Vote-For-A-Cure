class AddTagToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :tag, :string
  end

  def self.down
    remove_column :searches, :tag
  end
end
