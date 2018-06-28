require 'spec_helper'

describe PromotionService do
  let(:pricing_rules) { double('pricing_rules') }
  let(:item) { Item.new('101', 'test_item', 35 ) }
  subject { PromotionService.new([pricing_rules]) }

  describe '#price_update' do
    before do
      allow(pricing_rules).to receive(:type) { PricingRule::DISCOUNT_TYPE[:multipurchase_discount] }
      allow(pricing_rules).to receive(:apply) { 100 }
    end

    it 'pass pricing_rules with params' do
      expect(pricing_rules).to receive(:type) { PricingRule::DISCOUNT_TYPE[:multipurchase_discount] }
      expect(pricing_rules).to receive(:apply).with(item.code, 1)

      subject.price_update(item, 1)
    end

    it 'price calculation for item when pricing_rules matches' do
      price = subject.price_update(item, 1)
      expect(price).to eq(100)
    end

    it 'original price when no pricing_rules match' do
      promotion_service = PromotionService.new

      price = promotion_service.price_update(item, 1)
      expect(price).to eq(item.price)
    end
  end

  describe '#apply_deduction' do
    before do
      allow(pricing_rules).to receive(:type) { PricingRule::DISCOUNT_TYPE[:total_discount] }
      allow(pricing_rules).to receive(:apply) { 100 }
    end

    it 'pass the pricing_rules with subtotal' do
      expect(pricing_rules).to receive(:type) { PricingRule::DISCOUNT_TYPE[:total_discount] }
      expect(pricing_rules).to receive(:apply).with(10)

      subject.apply_deduction(10)
    end

    it 'total price calculation when pricing_rules match' do
      total = subject.apply_deduction(10)
      expect(total).to eq(100)
    end

    it 'original subtotal calculation when no pricing_rules match' do
      pricing_service = PromotionService.new

      total = pricing_service.apply_deduction(10)
      expect(total).to eq(10)
    end
  end
end
