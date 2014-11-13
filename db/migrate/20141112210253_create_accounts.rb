class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string 	:rut,				null: false, default: ""
      t.integer :id_cuenta_banco,	null: false, default: 0

      t.timestamps
    end
  end
end
