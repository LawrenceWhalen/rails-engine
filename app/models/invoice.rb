class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items

  belongs_to :customer
  belongs_to :merchant

  validates :status, presence: true
  validates :customer, presence: true
  validates :merchant, presence: true
end