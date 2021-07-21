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
    it 'returns errors if information is not provided' do
      merchant = create(:merchant)

      post api_v1_items_path()
      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:error][0][:merchant]).to eq(["must exist", "can't be blank"])
      expect(actual[:error][0][:name]).to eq(["can't be blank"])
      expect(actual[:error][0][:description]).to eq(["can't be blank"])
      expect(actual[:error][0][:unit_price]).to eq(["can't be blank", "is not a number"])
    end
    it 'returns an error if the name is a duplicate' do
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
      post api_v1_items_path(
        name: 'Test',
        description: 'A test item.',
        unit_price: 245.41,
        merchant_id: merchant.id
      )

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual[:error][0][:name]).to eq(["has already been taken"])
    end
  end
end