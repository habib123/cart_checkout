
class PromotionService
  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
  end

  def apply_deduction(subtotal)
    total = subtotal

    pricing_rules.each do |rule|
      if rule.type == PricingRule::DISCOUNT_TYPE[:total_discount]
        total = rule.apply(total)
      end
    end

    total
  end

  def price_update(product, count)
    reduced_price = nil

    pricing_rules.each do |rule|
      if rule.type == PricingRule::DISCOUNT_TYPE[:multipurchase_discount]
        reduced_price = rule.apply(product.code, count)
      end
    end

    if reduced_price.nil?
      product.price
    else
      reduced_price
    end
  end

  private

  attr_reader :pricing_rules
end
