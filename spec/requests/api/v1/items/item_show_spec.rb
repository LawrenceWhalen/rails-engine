require 'rails_helper'

RSpec.describe 'item api' do
  describe 'get: /items/:id' do
    it 'returns a single id' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get api_v1_item_path(item.id)
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq(Item.first.name)
    end
    it 'returns an error if the item does not exist' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get api_v1_item_path(898)

      expect(response).to have_http_status(404)
    end
  end
end