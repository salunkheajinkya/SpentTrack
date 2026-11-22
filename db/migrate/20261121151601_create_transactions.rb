
class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true

      t.decimal :amount, precision: 15, scale: 2, null: false
      t.date :transaction_date, null: false
      t.string :description
      t.string :merchant
      t.string :transaction_type, null: false
      t.string :reference_number
      t.string :external_id
      t.text :notes

      t.timestamps
    end

    add_index :transactions, :transaction_date
    add_index :transactions, :transaction_type
    add_index :transactions, [:account_id, :external_id],
              unique: true,
              where: "external_id IS NOT NULL"
  end
end

