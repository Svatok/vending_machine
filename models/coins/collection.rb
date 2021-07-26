# frozen_string_literal: true

module Coins
  class Collection < Array
    def find_by_value(value)
      detect { |coin| coin.value == value }
    end

    def balance
      sum { |coin| coin.value * coin.quantity }.to_f
    end
  end
end
