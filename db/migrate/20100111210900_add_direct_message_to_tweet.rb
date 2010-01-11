class AddDirectMessageToTweet < ActiveRecord::Migration
  def self.up
    add_column :tweets, :direct_message_id, :integer
  end

  def self.down
    remove_column :tweets, :direct_message_id
  end
end
