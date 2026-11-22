class CreateStatementImports < ActiveRecord::Migration[8.0]
  def change
    create_table :statement_imports do |t|
      t.references :account, null: false, foreign_key: true

      t.string :filename, null: false
      t.string :status, null: false, default: "pending"

      t.integer :total_rows, null: false, default: 0
      t.integer :imported_rows, null: false, default: 0
      t.integer :duplicate_rows, null: false, default: 0
      t.integer :failed_rows, null: false, default: 0

      t.jsonb :error_details, null: false, default: []

      t.timestamps
    end

    add_index :statement_imports, :status
  end
end
