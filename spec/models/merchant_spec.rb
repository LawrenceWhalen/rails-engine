require 'rails_helper'

RSpec.describe Merchant do
  describe 'assosiations' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices) }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end