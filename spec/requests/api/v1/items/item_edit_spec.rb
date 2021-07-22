require 'rails_helper'

RSpec.describe 'edit item api' do
  describe 'patch /items' do
    it 'edits an item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      patch "/api/v1/items/#{item.id}?name=Bandersnitch&description=Truer%20words&unit_price=14.56"

      edit_item = Item.first
      expect(edit_item.name).to eq('Bandersnitch')
      expect(edit_item.name).to_not eq(item.name)
      expect(edit_item.description).to eq('Truer words')
      expect(edit_item.description).to_not eq(item.description)
      expect(edit_item.unit_price).to eq(14.56)
      expect(edit_item.unit_price).to_not eq(item.unit_price)
    end
    it 'edits an item with partial edits' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      patch "/api/v1/items/#{item.id}?name=Bandersnitch"

      edit_item = Item.first
      expect(edit_item.name).to eq('Bandersnitch')
      expect(edit_item.name).to_not eq(item.name)
      expect(edit_item.description).to eq(item.description)
      expect(edit_item.unit_price).to eq(item.unit_price)
    end
    it 'errors out if atrributes are incorrect' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      patch "/api/v1/items/#{item.id}?unit_price=tim"

      actual = JSON.parse(response.body, symbolize_names: true)
      expect(actual[:message]).to eq('Your request could not be completed')
      expect(actual[:error][0][:unit_price]).to eq(['is not a number'])
    end
  end
end