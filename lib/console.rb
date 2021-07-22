# frozen_string_literal: true

class Console
  def self.run
    new
  end

  def initialize
    @products, @coins = DataLoader.load
  end
end
