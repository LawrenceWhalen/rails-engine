require 'rails_helper'

RSpec.describe 'delete item api' do
  describe 'delete: /items' do
    it 'removes the item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(1)

      delete "/api/v1/items/#{item.id}"

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(0)
    end
    it 'returns an error if item is not found' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      delete "/api/v1/items/45"
       
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:error][0]).to eq("Couldn't find Item with 'id'=45")
    end
  end
end                                         