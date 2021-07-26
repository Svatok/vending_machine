# frozen_string_literal: true

class VendingMachine
  attr_accessor :user_coins, :coins

  def initialize(coins:, products:)
    @coins = Coins::Collection.new(coins)
    @products = products
    @user_coins = Coins::Collection.new
  end

  def add_coin(value)
    result = Operations::AddCoin.new(coins: coins, user_coins: user_coins, value: value)
    result.call
    apply_result(result) if result.success

    result
  end

  def select_product(index)
    product = @products[index.to_i - 1]
    result = Operations::SelectProduct.new(product: product, user_coins: user_coins, coins: coins)
    result.call
    apply_result(result) unless result.change.nil?

    result
  end

  def user_balance
    @user_coins.balance
  end

  private

  def apply_result(result)
    @coins = result.coins
    @user_coins = result.user_coins
  end
end
