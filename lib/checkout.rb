
class Checkout
  def initialize(pricing_rules = [])
    @cart_container             = []
    @promotion_service    = PromotionService.new(pricing_rules)
  end

  def scan(item)
    cart_container << item
  end

  def subtotal
    subtotal = 0.00
    cart_container.each { |item| subtotal += item.price }

    subtotal
  end

  def total
    subtotal = 0.00

    cart_container.each do |item|
      quantity_of_item_in_cart_container = cart_container_count(item.code)
      subtotal += promotion_service.price_update(item, quantity_of_item_in_cart_container)
    end

    total = promotion_service.apply_deduction(subtotal)
    total.round(2)
  end

  private

  attr_reader :promotion_service
  attr_accessor :cart_container

  def cart_container_count(item_code)
    quantity = 0

    cart_container.each do |item|
      quantity += 1 if item.code == item_code
    end

    quantity
  end
end
