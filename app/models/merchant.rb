class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices

  validates :name, presence: true, uniqueness: true

  def self.find_name(name)
    Merchant.where("name ILIKE ?" ,"%#{name}%").order(:name)
  end
end