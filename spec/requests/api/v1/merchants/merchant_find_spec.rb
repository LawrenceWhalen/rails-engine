require 'rails_helper'

RSpec.describe 'find merchant paths' do
  describe 'find one merchant' do
    it 'returns one merchant by name fragment' do
      Merchant.create(name: 'Sammy Slims')
      Merchant.create(name: 'Smashing Slips')
      Merchant.create(name: 'Platinum')
      
      get '/api/v1/merchants/find', params: {name: 'Sli'}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq('Sammy Slims')
    end
    it 'returns an empty array if no matches' do
      Merchant.create(name: 'Sammy Slims')
      
      get '/api/v1/merchants/find?name=NOMATCH'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(0)
    end
  end
  describe 'all merchants by name fragment' do
    it 'returns all the merchants with that fragment' do
      Merchant.create(name: 'Sammy Slims')
      Merchant.create(name: 'Smashing Slips')
      Merchant.create(name: 'Platinum')
      
      get '/api/v1/merchants/find_all', params: {name: 'Sli'}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(2)
      expect(actual[:data][0][:attributes][:name]).to eq('Sammy Slims')
    end
    it 'returns an empty array if no matches' do
      Merchant.create(name: 'Sammy Slims')
      
      get '/api/v1/merchants/find_all?name=NOMATCH'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(0)
    end
  end
end