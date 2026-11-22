class AddStatementImportToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions,
                  :statement_import,
                  null: true,
                  foreign_key: true,
                  index: true
  end
end
