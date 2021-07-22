require 'rails_helper'

RSpec.describe 'items merchant api' do
  describe 'get /items/:id/merchant' do
    it 'returns an items merchant' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq(merchant.name)
    end
    it 'returns an error if item id is incorret' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/12/merchant"

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(404)
    end
  end
end