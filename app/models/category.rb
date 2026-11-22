class Category < ApplicationRecord
  has_many :transactions, dependent: :nullify

  validates :name, presence: true
  validates :category_type, presence: true
  validates :name, uniqueness: { scope: :category_type }
end
