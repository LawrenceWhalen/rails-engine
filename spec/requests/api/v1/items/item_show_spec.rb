require 'rails_helper'

RSpec.describe 'item api' do
  describe 'get: /items/:id' do
    it 'returns a single id' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get api_v1_item_path(item.id)
      actual = JSON.parse(response.body, symbolize_names: true)
      binding.pry
      expect(actual)
    end
  end
end