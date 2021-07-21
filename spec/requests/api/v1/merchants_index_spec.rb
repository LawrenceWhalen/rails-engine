require 'rails_helper'

RSpec.describe 'merchants api' do
  describe 'get: /merchants ' do
    it 'retuns 20 merchants' do
      create_list(:merchant, 40)
      
      get api_v1_merchants_path
      actual = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(20)
    end
    it 'returns the same set on default or page one' do
      create_list(:merchant, 40)
      
      get api_v1_merchants_path
      actual_1 = JSON.parse(response.body, symbolize_names: true)
      get api_v1_merchants_path(page: 1)
      actual_2 = JSON.parse(response.body, symbolize_names: true)
      expect(actual_1).to eq(actual_2)
    end
    it 'returns the next 20 on page 2' do
      create_list(:merchant, 40)

      get api_v1_merchants_path(page: 2)
      actual_1 = JSON.parse(response.body, symbolize_names: true)
      get api_v1_merchants_path(page: 1)
      actual_2 = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(200)
      expect(actual_1.keys.include?(:data)).to eq(true)
      expect(actual_1[:data].length).to eq(20)
      expect(actual_1).to_not eq(actual_2)
    end
    it 'returns more responses based on per page querry' do
      create_list(:merchant, 40)

      get api_v1_merchants_path(per_page: 30)
      actual = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(30)
    end
    it 'returns the first 20 results if bad page or per-page is passed' do
      create_list(:merchant, 40)

      get api_v1_merchants_path(page: -3, per_page: -1)
      actual = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(actual.keys.include?(:data)).to eq(true)
      expect(actual[:data].length).to eq(20)
    end
  end
end