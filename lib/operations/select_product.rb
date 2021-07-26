# frozen_string_literal: true

module Operations
  class SelectProduct
    attr_reader :product, :user_coins, :change, :error_key, :success, :coins

    def initialize(product:, user_coins:, coins:)
      @product = product
      @user_coins = user_coins.dup
      @coins = coins.dup
      @success = true
    end

    def call
      calculate_user_balance
      validate_product
      calculate_change
      validate_change
      apply_changes
    rescue Errors::ProductValidationError
      @success = false
      apply_changes if change
    end

    private

    attr_reader :user_balance

    def calculate_user_balance
      @user_balance = user_coins.balance
    end

    def validate_product
      @error_key = 'wrong_product' if product.nil?
      @error_key = 'out_of_stock' if error_key.nil? && product.quantity.zero?
      @error_key = 'not_enough_balance' if error_key.nil? && product.price > user_balance
      raise Errors::ProductValidationError if @error_key
    end

    def calculate_change
      new_user_balance = user_balance - product.price
      @change = coins.sort_by(&:value).reverse.map do |coin|
        quantity = coin.available_quantity(new_user_balance)
        next if quantity.zero?

        new_user_balance -= quantity * coin.value
        Coin.new(value: coin.value, quantity: quantity)
      end.compact
    end

    def validate_change
      left_balance = user_balance - product.price - @change.sum(&:value)
      return if left_balance.zero?

      @error_key = 'not_enough_change'
      @change = user_coins
      raise Errors::ProductValidationError
    end

    def apply_changes
      @product.quantity -= 1
      @user_coins = Coins::Collection.new
      change.each do |change_coin|
        coin = coins.find_by_value(change_coin.value)
        coin.quantity -= change_coin.quantity
      end
    end
  end
end
