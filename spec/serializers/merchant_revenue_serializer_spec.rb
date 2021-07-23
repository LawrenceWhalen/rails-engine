require 'rails_helper'

RSpec.describe 'merchant_revenue_serializer' do
  describe 'creation' do
    it 'creates an merchant revenue object' do
      merchantrevenue = MerchantRevenueSerializer.new(MerchantRev.new(id: 1, revenue: 12))
      expect(merchantrevenue.class).to eq(MerchantRevenueSerializer)
    end
  end
end