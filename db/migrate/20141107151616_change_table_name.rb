class ChangeTableName < ActiveRecord::Migration
  def change
  	rename_table :usuarios, :users
  end
end
