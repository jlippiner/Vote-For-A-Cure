class ChangeActiveToBooleanInDm < ActiveRecord::Migration
def self.up
    change_column :direct_messages, :active, :boolean
  end

  def self.down
    change_column :direct_messages, :active, :string
  end
end
