require 'rails helper'

RSpec.describe 'find merchant paths' do
  describe 'find one merchant' do
    it 'returns one merchant by name fragment' do
      Merchant.new(name: 'Sammy Slims')
      Merchant.new(name: 'Smashing Slips')
      Merchant.new(name: 'Platinum')
      
      get '/api/v1/merchants/find?name=sli'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq('Sammy Slims')
    end
    it 'returns one merchant by name fragment' do
      Merchant.new(name: 'Sammy Slims')
      
      get '/api/v1/merchants/find?name=NOMATCH'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(0)
    end
  end
end