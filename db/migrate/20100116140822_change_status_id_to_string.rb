class ChangeStatusIdToString < ActiveRecord::Migration
  def self.up
    change_column :searches, :status_id, :string
        change_column :searches, :from_user_id, :string
  end

  def self.down
    change_column :searches, :status_id, :string
  end
end
