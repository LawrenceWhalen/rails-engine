require 'rails_helper'

RSpec.describe 'merchants revenue' do
  before :each do
    @merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: @merchant_1)
    item_2 = create(:item, merchant: @merchant_1)
    item_3 = create(:item, merchant: @merchant_1)
    item_4 = create(:item, merchant: @merchant_1)
    item_5 = create(:item, merchant: @merchant_1)

    customer = create(:customer)

    @invoice_1 = create(:invoice, merchant: @merchant_1, customer: customer)
    @invoice_2 = create(:invoice, merchant: @merchant_1, customer: customer)
    @invoice_3 = create(:invoice, merchant: @merchant_1, customer: customer)
    @invoice_4 = create(:invoice, merchant: @merchant_1, customer: customer)
    @invoice_5 = Invoice.create(status: 'unshipped', merchant: @merchant_1, customer: customer)

    invoice_item_1 = InvoiceItem.create(quantity: 2, unit_price: 10.00, item: item_1, invoice: @invoice_1)
    invoice_item_2 = InvoiceItem.create(quantity: 3, unit_price: 10.00, item: item_2, invoice: @invoice_2)
    invoice_item_3 = InvoiceItem.create(quantity: 2, unit_price: 20.00, item: item_3, invoice: @invoice_3)
    invoice_item_4 = InvoiceItem.create(quantity: 2, unit_price: 100.00, item: item_4, invoice: @invoice_4)
    invoice_item_5 = InvoiceItem.create(quantity: 2, unit_price: 100.00, item: item_5, invoice: @invoice_5)

    @transaction_1 = Transaction.create(invoice: @invoice_1, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123')
    @transaction_6 = Transaction.create(invoice: @invoice_1, result: 'failed', credit_card_number: 123, credit_card_expiration_date: '123')
    @transaction_2 = Transaction.create(invoice: @invoice_2, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123')
    @transaction_3 = Transaction.create(invoice: @invoice_3, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123')
    @transaction_4 = Transaction.create(invoice: @invoice_4, result: 'failed', credit_card_number: 123, credit_card_expiration_date: '123')
    @transaction_5 = Transaction.create(invoice: @invoice_5, result: 'success', credit_card_number: 123, credit_card_expiration_date: '123') 
    # Invoices must have a successful transaction and be shipped to the customer to be considered as revenue.
  end
  describe 'get: /revenue/merchants/:id' do
    it 'returns a merchants ordered total revenue' do
      get "/api/v1/revenue/merchants/#{@merchant_1.id}"

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:revenue]).to eq(90.0)
    end
    it 'returns 0 if merchants have no revenue' do
      @transaction_1.destroy
      @transaction_2.destroy
      @transaction_3.destroy

      get "/api/v1/revenue/merchants/#{@merchant_1.id}"

      actual = JSON.parse(response.body, symbolize_names: true)
      
      expect(actual[:data][:attributes][:revenue]).to eq(0)
    end
  end
  describe 'bad api calls' do
    it 'returns an error if no merchant found' do
      get '/api/v1/revenue/merchants/787'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:error].length).to eq(2)
      expect(actual[:error][0]).to eq("Couldn't find Merchant with 'id'=787")
    end
  end
end