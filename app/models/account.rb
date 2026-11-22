class Account < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error

  validates :name, presence: true
  validates :account_type, presence: true
  validates :currency, presence: true
end
