require 'rails_helper'

RSpec.describe 'merchants api' do
  describe 'get: /merchants ' do
    it 'retuns 20 merchants' do
      create_list(:merchant, 20)
      
      get '/api/v1/merchants'

      expect(response).to have_http_status(200)
      binding.pry
      expect(response).to 
    end
  end
end