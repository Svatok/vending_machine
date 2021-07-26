# frozen_string_literal: true

class Coin
  AVAILABLE_VALUES = [5.00, 3.00, 2.00, 1.00, 0.50, 0.25].freeze

  attr_accessor :value, :quantity

  def initialize(attributes)
    @value = attributes[:value]
    @quantity = attributes[:quantity]
  end

  def attributes
    {
      value: value,
      quantity: quantity
    }
  end

  def available_quantity(amount)
    needed_quantity = amount.div(value)
    needed_quantity <= quantity ? needed_quantity : quantity
  end
end
