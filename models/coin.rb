# frozen_string_literal: true

class Coin
  attr_accessor :value, :quantity

  def initialize(attributes)
    @value = attributes[:value]
    @quantity = attributes[:quantity]
  end
end
