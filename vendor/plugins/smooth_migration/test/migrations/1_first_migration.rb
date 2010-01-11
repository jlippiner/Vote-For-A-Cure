class FirstMigration < ActiveRecord::Migration
  def self.up
    add_column :non_existent_table, :foo, :string
    create_table :users do |t|
      t.column :name, :string
    end
    add_column :users, :email_address, :string
  end
  
  def self.down
    drop_table :bogus
    drop_table :users
  end
end