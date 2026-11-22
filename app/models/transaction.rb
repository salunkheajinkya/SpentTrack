class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category, optional: true
  belongs_to :statement_import, optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_date, presence: true

  validates :transaction_type,
            presence: true,
            inclusion: { in: %w[income expense transfer] }
end
