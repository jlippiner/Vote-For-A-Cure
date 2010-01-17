class AddInProcessToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :in_process, :boolean, :default => false 
  end

  def self.down
    remove_column :searches, :in_process
  end
end
