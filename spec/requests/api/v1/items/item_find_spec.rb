require 'rails_helper'

RSpec.describe 'find item paths' do
  describe 'find one item by name' do
    it 'returns one item by name fragment' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      
      get '/api/v1/items/find', params: {name: 'Sli'}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq('Sammy Slims')
    end
    it 'returns no item if there is no match' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      
      get '/api/v1/items/find?name=NOMATCH'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(0)
    end
  end
  describe 'all items by name fragment' do
    it 'returns all the items with that fragment' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      
      get '/api/v1/items/find_all', params: {name: 'Sli'}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(2)
      expect(actual[:data][0][:attributes][:name]).to eq('Sammy Slims')
    end
    it 'returns and empty data set if nothing is found' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      
      get '/api/v1/items/find_all', params: {name: 'NOMATCH'}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(0)
    end
  end
  describe 'one item by price' do
    it 'returns an item at a price higher than minimum' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 1.00, merchant_id: merchant.id)

      get '/api/v1/items/find', params: {min_price: 14.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq('Sammy Slims')
    end
    it 'returns an item at a price lower than maximum' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 1.00, merchant_id: merchant.id)

      get '/api/v1/items/find', params: {max_price: 14.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq('Platinum')
    end
    it 'returns an item at a price between min and max' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 4.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 2.00, merchant_id: merchant.id)

      get '/api/v1/items/find', params: {max_price: 14.00, min_price: 3.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(3)
      expect(actual[:data][:attributes][:name]).to eq('Smashing Slips')
    end
  end
  describe 'all items by price' do
    it 'returns all items at a price higher than minimum' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 1.00, merchant_id: merchant.id)

      get '/api/v1/items/find_all', params: {min_price: 14.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(2)
      expect(actual[:data][0][:attributes][:name]).to eq('Sammy Slims')
      expect(actual[:data][1][:attributes][:name]).to eq('Smashing Slips')
    end
    it 'returns an item at a price lower than maximum' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 14.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 1.00, merchant_id: merchant.id)

      get '/api/v1/items/find_all', params: {max_price: 14.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(2)
      expect(actual[:data][0][:attributes][:name]).to eq('Platinum')
      expect(actual[:data][1][:attributes][:name]).to eq('Smashing Slips')
    end
    it 'returns an item at a price between min and max' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 4.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 2.00, merchant_id: merchant.id)

      get '/api/v1/items/find_all', params: {max_price: 14.00, min_price: 3.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)

      expect(actual[:data].length).to eq(1)
      expect(actual[:data][0][:attributes][:name]).to eq('Smashing Slips')
    end
  end
  describe 'incorrect sent data' do
    it 'returns an error if price and name are passed' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 2.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 4.00, merchant_id: merchant.id)

      get '/api/v1/items/find', params: {max_price: 14.00, name: 'sli'}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:error)).to eq(true)
      expect(actual[:error][0]).to eq('Cannot pass both price and name')
    end
    it 'returns an error if min price is greater than max price' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 2.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 4.00, merchant_id: merchant.id)

      get '/api/v1/items/find', params: {max_price: 14.00, min_price: 167.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:error)).to eq(true)
      expect(actual[:error][1]).to eq('Minimum price cannot be higher than maximum price')
    end
  end
  describe 'no matches price' do
    it 'returns an empty array if no items match price restrictions' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 2.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 4.00, merchant_id: merchant.id)

      get '/api/v1/items/find', params: {max_price: 1.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(0)
    end
    it 'returns an empty array if no items match price restrictions' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 2.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 4.00, merchant_id: merchant.id)

      get '/api/v1/items/find_all', params: {max_price: 1.00}

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(0)
    end
    it 'returns an error if params are incorrect' do
      merchant = create(:merchant)
      Item.create(name: 'Sammy Slims', description: 'test', unit_price: 15.00, merchant_id: merchant.id)
      Item.create(name: 'Smashing Slips', description: 'test', unit_price: 2.00, merchant_id: merchant.id)
      Item.create(name: 'Platinum', description: 'test', unit_price: 4.00, merchant_id: merchant.id)

      get '/api/v1/items/find_all'

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(actual.keys.include?(:error)).to eq(true)
      expect(actual[:error].length).to eq(2)
    end
  end
end