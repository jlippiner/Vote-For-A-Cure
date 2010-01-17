class AddAllowRepliesToTweet < ActiveRecord::Migration
  def self.up
    add_column :tweets, :allow_replies, :boolean, :default => true 
  end

  def self.down
    remove_column :tweets, :allow_replies
  end
end
