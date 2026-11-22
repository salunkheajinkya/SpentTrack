class StatementImport < ApplicationRecord
  belongs_to :account

  has_many_attached :files
  has_many :transactions, dependent: :nullify
end
