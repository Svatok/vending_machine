# frozen_string_literal: true

class Product
  attr_accessor :name, :price, :quantity

  def initialize(attributes)
    @name = attributes[:name]
    @price = attributes[:price]
    @quantity = attributes[:quantity]
  end

  def attributes
    {
      name: name,
      price: price,
      quantity: quantity
    }
  end
end
