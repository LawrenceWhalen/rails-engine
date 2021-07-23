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

  def self.unshipped_revenue
    joins(items: [invoices: :transactions])
    .select('merchants.id, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
    .where('transactions.result = ? AND invoices.status = ?', 'success', 'unshipped')
    .group('merchants.id')
    .order('potential_revenue DESC')
  end

  def total_revenue
    items.joins(invoices: :transactions)
    .where('transactions.result = ? AND invoices.status = ?', 'success', 'shipped')
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end