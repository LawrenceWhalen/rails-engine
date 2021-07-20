class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :unit_price, presence: true, numericality: true
  validates :invoice, presence: true
  validates :item, presence: true
end