class AddUserIdToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :user_id, :integer
  end

  def self.down
    remove_column :searches, :user_id
  end
end
