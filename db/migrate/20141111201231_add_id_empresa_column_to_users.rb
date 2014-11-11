class AddIdEmpresaColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :id_empresa, :int, :null => true
  end
end
