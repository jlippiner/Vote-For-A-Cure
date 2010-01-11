class ChangeTweetTable < ActiveRecord::Migration
  def self.up
    drop_table :tweets
    create_table :tweets do |t|
      t.integer :user_id
      t.boolean :send_dm, :default => true 
      t.boolean :follow_us, :default => true 
      t.boolean :completed, :default => false 
      t.integer :status_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
    create_table :tweets do |t|
      t.string :twitter_id
      t.boolean :sent_dm
      t.boolean :is_following
      t.integer :number_of_friends
      t.integer :number_of_followers
      t.string :profile_pic_url
      t.boolean :completed
      t.integer :status_id
      t.timestamps
    end
  end
end
