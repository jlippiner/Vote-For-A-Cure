class CreateAdminSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :status_id
      t.string :from_user
      t.integer :from_user_id
      t.string :message
      t.timestamps
    end
  end
  
  def self.down
    drop_table :searches
  end
end
