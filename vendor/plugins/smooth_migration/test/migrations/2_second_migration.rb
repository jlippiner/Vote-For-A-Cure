class SecondMigration < ActiveRecord::Migration
  def self.up
    add_column :foo, :bar, :string
    add_column :users, :nickname, :string
  end
  
  def self.down
    remove_column :bar, :foo
    remove_column :users, :nickname
  end
end