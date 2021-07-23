require 'rails_helper'

RSpec.describe Merchant do
  describe 'assosiations' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices) }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'class methods' do
    describe '.find_name' do
      it 'returns a merchant based on a name piece' do
        merchant = Merchant.create(name: 'Saddle Bronk')

        actual = Merchant.find_name('sad')

        expect(actual[0]).to eq(merchant)
      end
    end
    describe '.top_merchants' do
      it 'returns all merchants ordered by revenue' do
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

        actual = Merchant.top_merchants

        expect(actual[0]).to eq(merchant_3)
        expect(actual[1]).to eq(merchant_2)
        expect(actual[2]).to eq(merchant_1)
      end
    end
    describe '.unshipped_revenue' do
      it 'returns merchants with the most unshipped revenue' do
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

        invoice_1 = Invoice.create(status: 'unshipped', merchant: merchant_1, customer: customer)
        invoice_2 = Invoice.create(status: 'unshipped', merchant: merchant_2, customer: customer)
        invoice_3 = Invoice.create(status: 'unshipped', merchant: merchant_3, customer: customer)
        invoice_4 = Invoice.create(status: 'shipped', merchant: merchant_4, customer: customer)
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

        actual = Merchant.unshipped_revenue

        expect(actual[0]).to eq(merchant_5)
        expect(actual[1]).to eq(merchant_3)
        expect(actual[2]).to eq(merchant_2)
      end
      describe '.top_items' do
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
        it 'returns an array of merchants ordered by items sold' do
          actual = Merchant.top_items

        expect(actual[0]).to eq(merchant_3)
        expect(actual[1]).to eq(merchant_2)
        expect(actual[2]).to eq(merchant_1)
          
        end
      end
    end
  end
  describe 'instance methods' do
    describe '#total_revenue' do
      it 'returns a merchants total revenue' do
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

        actual = @merchant_1.total_revenue

        expect(actual).to eq(90)
      end
    end
  end
end