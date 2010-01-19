class AddPostedAtToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :posted_at, :timestamp
  end

  def self.down
    remove_column :searches, :posted_at
  end
end
