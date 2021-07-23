class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices

  validates :name, presence: true, uniqueness: true

  def self.find_name(name)
    Merchant.where("name ILIKE ?" ,"%#{name}%").order(:name)
  end

  def self.top_merchants
    joins(items: [invoices: :transactions])
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ? AND invoices.status = ?', 'success', 'shipped')
    .group('merchants.id')
    .order('revenue DESC')
  end
end