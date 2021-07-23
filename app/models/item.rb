class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates :merchant, presence: true

  def self.find_name(name)
    Item.where("name ILIKE ?" ,"%#{name}%").order(:name)
  end

  def self.find_price(min_max)
    if min_max[:min_price] && min_max[:max_price]
      Item.where("unit_price >= :min_price AND unit_price <= :max_price",
        {min_price: min_max[:min_price], max_price: min_max[:max_price]}).order(:name)
    elsif min_max[:min_price]
      Item.where("unit_price >= :min_price",
        {min_price: min_max[:min_price]}).order(:name)
    else
      Item.where("unit_price <= :max_price",
        {max_price: min_max[:max_price]}).order(:name)
    end
  end

  def self.top_items
    joins(invoices: :transactions)
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ? AND invoices.status = ?', 'success', 'shipped')
    .group('items.id')
    .order('revenue DESC')
  end
end