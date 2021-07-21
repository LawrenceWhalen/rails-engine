require 'rails_helper'

RSpec.describe 'merchants api' do
  describe 'get: merchants/:id' do
    it 'returns a single merchant by id' do
      merchant = create(:merchant)
      
      get api_v1_merchant_path(id: merchant.id)

      actual = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(3)

      expect(actual[:data][:attributes][:name]).to eq(merchant.name)
    end

    it 'returns an error when an incorrect id is sent' do
      get api_v1_merchant_path(4596)
      
      expect(response).to have_http_status(404)
    end
  end
end