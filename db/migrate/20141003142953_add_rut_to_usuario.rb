class AddRutToUsuario < ActiveRecord::Migration
  def change
    add_column :usuarios, :rut, :string
  end
end
