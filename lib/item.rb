
class Item
  attr_reader :price, :code, :name

  def initialize(code, name, price)
    @code   = code
    @name   = name
    @price  = price
  end
end
