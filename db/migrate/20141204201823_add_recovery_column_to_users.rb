class AddRecoveryColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recovery, :boolean, default: false
  end
end
