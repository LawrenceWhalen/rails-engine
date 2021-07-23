require 'rails_helper'

RSpec.describe Item do
  describe 'associations' do
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
    it { should validate_presence_of(:merchant) }
  end

  describe '.top_items' do
    it 'returns all items ordered by revenue' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      merchant_4 = create(:merchant)
      merchant_5 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)
      item_4 = create(:item, merchant: merchant_4)
      item_5 = create(:item, merchant: merchant_5)

      customer = create(:customer)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer)
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer)
      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer)
      invoice_4 = create(:invoice, merchant: merchant_4, customer: customer)
      invoice_5 = Invoice.create(status: 'unshipped', merchant: merchant_5, customer: customer)

      invoice_item_1 = InvoiceItem.create(quantity: 2, unit_price: 10.00, item: item_1, invoice: invoice_1)
      invoice_item_2 = InvoiceItem.create(quantity: 3, unit_price: 10.00, item: item_2, invoice: invoice_2)
      invoice_item_3 = InvoiceItem.create(quantity: 2, unit_price: 20.00, item: item_3, invoice: invoice_3)
      invoice_item_4 = InvoiceItem.create(quantity: 2, unit_price: 100.00, item: item_4, invoice: invoice_4)
      invoice_item_5 = InvoiceItem.create(quantity: 2, unit_price: 100.00, item: item_5, invoice: invoice_5)

      transaction_1 = Transaction.create(invoice: invoice_1, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123')
      transaction_2 = Transaction.create(invoice: invoice_1, result: 'failed', credit_card_number: 123, credit_card_expiration_date: '123')
      transaction_2 = Transaction.create(invoice: invoice_2, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123')
      transaction_3 = Transaction.create(invoice: invoice_3, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123')
      transaction_4 = Transaction.create(invoice: invoice_4, result: 'failed', credit_card_number: 123, credit_card_expiration_date: '123')
      transaction_5 = Transaction.create(invoice: invoice_5, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123') 

      actual = Item.top_items

      expect(actual[0]).to eq(item_3)
      expect(actual[1]).to eq(item_2)
      expect(actual[2]).to eq(item_1)
    end
  end
end