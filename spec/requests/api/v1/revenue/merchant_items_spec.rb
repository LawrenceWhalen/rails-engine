require 'rails_helper'

RSpec.describe 'merchants with most items sold' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)
    @merchant_5 = create(:merchant)

    item_1 = create(:item, merchant: @merchant_1)
    item_2 = create(:item, merchant: @merchant_2)
    item_3 = create(:item, merchant: @merchant_3)
    item_4 = create(:item, merchant: @merchant_4)
    item_5 = create(:item, merchant: @merchant_5)

    customer = create(:customer)

    @invoice_1 = create(:invoice, merchant: @merchant_1, customer: customer)
    @invoice_2 = create(:invoice, merchant: @merchant_2, customer: customer)
    @invoice_3 = create(:invoice, merchant: @merchant_3, customer: customer)
    @invoice_4 = create(:invoice, merchant: @merchant_4, customer: customer)
    @invoice_5 = Invoice.create(status: 'unshipped', merchant: @merchant_5, customer: customer)

    invoice_item_1 = InvoiceItem.create(quantity: 2, unit_price: 10.00, item: item_1, invoice: @invoice_1)
    invoice_item_2 = InvoiceItem.create(quantity: 3, unit_price: 10.00, item: item_2, invoice: @invoice_2)
    invoice_item_3 = InvoiceItem.create(quantity: 4, unit_price: 20.00, item: item_3, invoice: @invoice_3)
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
  describe 'get: /merchants/most_items' do
    it 'returns a specified number of merchants ordered by total items sold' do
      get '/api/v1/merchants/most_items?quantity=3'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][0][:attributes][:name]).to eq(@merchant_3.name)
      expect(actual[:data][2][:attributes][:name]).to eq(@merchant_1.name)
    end
    it 'can return fewer than the number of eligable merchants' do
      get '/api/v1/merchants/most_items?quantity=1'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(1)
      expect(actual[:data][0][:attributes][:name]).to eq(@merchant_3.name)
    end
    it 'does not return merchants without real revenue' do
      get '/api/v1/merchants/most_items?quantity=20'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][0][:attributes][:name]).to eq(@merchant_3.name)
      expect(actual[:data][2][:attributes][:name]).to eq(@merchant_1.name)
    end
    it 'returns an empty array if no merchants have revenue' do
      @transaction_1.destroy
      @transaction_2.destroy
      @transaction_3.destroy

      get '/api/v1/merchants/most_items?quantity=3'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(0)
    end
  end
  describe 'bad api calls' do
    it 'returns an error if the quantity is not a positive number' do
      get '/api/v1/merchants/most_items?quantity=0'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:error].length).to eq(1)
      expect(actual[:error][0]).to eq('Quantity must be one or greater')
    end
    it 'error out if no quantity given' do
      get '/api/v1/merchants/most_items'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:error].length).to eq(1)
      expect(actual[:error][0]).to eq('Quantity must be one or greater')
    end
  end
end