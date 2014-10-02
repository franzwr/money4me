class DropUser < ActiveRecord::Migration
  def change
  	drop_table :usuarios
  end
end
