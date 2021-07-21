require 'rails_helper'

RSpec.describe 'merchants item api' do
  describe 'get: /merchants/:id/items' do
    it 'returns all of the items for one merchant' do
      merchant = create(:merchant)
      create_list(:item, 5, merchant: merchant)

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)
      
      expect(actual[:data].length).to eq(5)
      expect(actual[:data].first[:attributes][:name]).to eq(Item.first.name)

      create(:item, merchant: merchant)

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)
      expect(actual[:data].length).to eq(6)
    end
    it 'returns no items if a merchant has none' do
      merchant = create(:merchant)

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)
      expect(actual[:data].length).to eq(0)
    end
    it 'returns an error if no merchant is found' do
      create(:merchant)

      get api_v1_merchant_items_path(78)

      expect(response).to have_http_status(404)
    end
  end
end