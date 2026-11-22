
class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :account_type, null: false
      t.string :institution
      t.decimal :opening_balance, precision: 15, scale: 2, default: 0.00, null: false
      t.string :currency, default: "INR", null: false

      t.timestamps
    end

    add_index :accounts, :name
    add_index :accounts, :account_type
  end
end

