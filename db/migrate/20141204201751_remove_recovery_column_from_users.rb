class RemoveRecoveryColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :recovery, :boolean
  end
end
