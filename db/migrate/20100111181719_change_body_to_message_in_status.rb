class ChangeBodyToMessageInStatus < ActiveRecord::Migration
  def self.up
    rename_column :statuses, :body, :message
  end

  def self.down
    rename_column :statuses, :message, :body
  end
end
