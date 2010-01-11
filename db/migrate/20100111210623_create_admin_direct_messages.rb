class CreateAdminDirectMessages < ActiveRecord::Migration
  def self.up
    create_table :direct_messages do |t|
      t.string :name
      t.string :message
      t.string :active
      t.timestamps
    end
  end
  
  def self.down
    drop_table :direct_messages
  end
end
