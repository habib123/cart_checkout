require 'spec_helper'

describe PricingRule do
  subject { PricingRule.new(PricingRule::DISCOUNT_TYPE[:total_discount]) {} }

  describe 'rule type' do
    it 'check rule type as value' do
      expect(subject.type).to eq(1)
    end
  end

  describe 'check pricing rule block' do
    it 'without arguments' do
      value = false
      pricing_rule = PricingRule.new(PricingRule::DISCOUNT_TYPE[:total_discount])do
        value = true
      end
      expect(pricing_rule.apply).to be_truthy
    end

    it 'with one argument' do
      pricing_rule = PricingRule.new(PricingRule::DISCOUNT_TYPE[:total_discount]) do |v|
        v
      end
      expect(pricing_rule.apply('test')).to eq('test')
    end

    it 'with two arguments' do
      pricing_rule = PricingRule.new(PricingRule::DISCOUNT_TYPE[:total_discount])do|v1, v2|
        "#{v1}-#{v2}"
      end
      expect(pricing_rule.apply('test', 'foo')).to eq('test-foo')
    end
  end

  describe 'method multipurchase_pricingrule' do
    subject { PricingRule.new_multipurchase_pricingrule('001', 100, 2) }

    it 'test instance of pricing rule' do
      expect(subject).to be_a_kind_of(PricingRule)
    end

    it 'discount calculation when quantity is equal break price' do
      price = subject.apply('001', 2)
      expect(price).to eq(100)
    end

    it 'discount calculation when quantity is more than break price' do
      price = subject.apply('001', 3)
      expect(price).to eq(100)
    end

    it 'no discount when quantity is less than break price' do
      price = subject.apply('001', 1)
      expect(price).to be_nil
    end

    it 'no discount when item code is different' do
      price = subject.apply('002', 1)
      expect(price).to be_nil
    end
  end

  describe 'method total discount' do
    subject { PricingRule.new_discount_pricingrule(100, 50) } # minimum_pay, discount_percentage

    it 'check instance of PricingRule' do
      expect(subject).to be_a_kind_of(PricingRule)
    end

    it 'discount calculation when quantity is equal to break price' do
      price = subject.apply(100)
      expect(price).to eq(50)
    end

    it 'discount calculation when quantity is more than break price' do
      price = subject.apply(200)
      expect(price).to eq(100)
    end

    it 'no discount when quantity is less than break price' do
      price = subject.apply(97)
      expect(price).to eq(97)
    end
  end
end
