require 'rails_helper'

RSpec.describe 'post items api' do
  describe 'post: /items' do
    it 'creates a new item' do
      merchant = create(:merchant)

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(0)

      post api_v1_items_path(
        name: 'Test',
        description: 'A test item.',
        unit_price: 245.41,
        merchant_id: merchant.id
      )

      get api_v1_merchant_items_path(merchant_id: merchant.id)
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:data].length).to eq(1)
    end
  end
end