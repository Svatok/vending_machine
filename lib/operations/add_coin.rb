# frozen_string_literal: true

module Operations
  class AddCoin
    attr_reader :user_coins, :coins, :success, :error_key

    def initialize(value:, user_coins:, coins:, quantity: 1)
      @value = value.to_f
      @quantity = quantity
      @user_coins = user_coins.dup
      @coins = coins.dup
      @success = true
    end

    def call
      find_coin
      update_coin
      find_user_coin
      user_coin ? update_user_coin : new_user_coin
    rescue Errors::CoinNotFoundError
      @success = false
    end

    private

    attr_reader :value, :coin, :user_coin, :quantity

    def find_coin
      @coin = coins.find_by_value(value)
      return if @coin

      @error_key = 'coin_not_found'
      raise Errors::CoinNotFoundError
    end

    def update_coin
      coin.quantity += quantity
    end

    def find_user_coin
      @user_coin = user_coins.find_by_value(value)
    end

    def update_user_coin
      user_coin.quantity += quantity
    end

    def new_user_coin
      @user_coin = Coin.new(value: value, quantity: quantity)
      @user_coins << @user_coin
    end
  end
end
