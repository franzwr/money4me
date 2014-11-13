class AddIdEmpresaColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :id_empresa, :integer
  end
end
