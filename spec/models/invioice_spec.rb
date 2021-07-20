require 'rails_helper'

RSpec.describe Invoice do
  describe 'assosiations' do
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to(:merchant) }
    it { should belong_to(:customer) }
  end
     
  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:customer) }
    it { should validate_presence_of(:merchant) }
  end
end                                   