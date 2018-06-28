
class PricingRule
  attr_reader :type

  DISCOUNT_TYPE = { multipurchase_discount: 0, total_discount: 1 }

  def initialize(type, &rule_block)
    @rule_block  = rule_block
    @type   = type
  end

  def self.new_discount_pricingrule(minimum_pay, discount_percentage)
    PricingRule.new(PricingRule::DISCOUNT_TYPE[:total_discount]) do |subtotal|
      if subtotal >= minimum_pay
        subtotal - subtotal * discount_percentage / 100
      else
        subtotal
      end
    end
  end

  def self.new_multipurchase_pricingrule(item_code, new_price, break_price)
    PricingRule.new(PricingRule::DISCOUNT_TYPE[:multipurchase_discount]) do |code, quantity|
      if code == item_code && quantity >= break_price
        new_price
      end
    end
  end

  def apply(*agrs)
    case rule_block.arity
    when 0
      rule_block.call
    when 1
      rule_block.call(agrs[0])
    when 2
      rule_block.call(agrs[0], agrs[1])
    end
  end

  private

  attr_reader :rule_block
end
