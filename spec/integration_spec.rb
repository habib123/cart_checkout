require 'spec_helper'

describe 'CartSystem' do
  let(:test_item1) { Item.new('001', 'Curry Sauce ', 1.95) }
  let(:test_item2) { Item.new('002', 'Pizza', 5.99) }
  let(:test_item3) { Item.new('003', 'Men T-Shirt', 25.00) }
  subject(:checkout) { Checkout.new(@pricing_rules) }

  before(:all) do
    @pricing_rules = []
    @pricing_rules << PricingRule.new_discount_pricingrule(30, 10)
    @pricing_rules << PricingRule.new_multipurchase_pricingrule('002', 3.99, 2)
  end

  describe 'Test case 1' do
    before do
      checkout.scan(test_item1)
      checkout.scan(test_item2)
      checkout.scan(test_item3)
    end

    it 'total correct price' do
      expect(checkout.total).to eq(29.65)
    end
  end

  describe 'Test case 2' do
    before do
      checkout.scan(test_item2)
      checkout.scan(test_item1)
      checkout.scan(test_item2)
    end

    it 'total correct price' do
      expect(checkout.total).to eq(9.93)
    end
  end

  describe 'Test case 3' do
    before do
      checkout.scan(test_item2)
      checkout.scan(test_item1)
      checkout.scan(test_item2)
      checkout.scan(test_item3)
    end

    it 'total correct prce' do
      expect(checkout.total).to eq(31.44)
    end
  end
end
