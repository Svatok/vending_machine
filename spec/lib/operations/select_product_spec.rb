require 'spec_helper'

RSpec.describe Operations::SelectProduct do
  subject { described_class.new(product: product, user_coins: user_coins, coins: coins) }

  let(:product) do
    Product.new(
      name: FFaker::Product.product_name,
      price: product_price,
      quantity: product_quantity
    )
  end
  let(:product_price) { rand(1.00..2.00) }
  let(:product_quantity) { rand(1..5) }

  let(:coin) do
    Coin.new(
      value: 5.00,
      quantity: coin_quantity
    )
  end
  let(:coin_quantity) { rand(1..5) }

  let(:coins) { Coins::Collection.new }
  let(:user_coins) { Coins::Collection.new }
  let(:value) { coin.value }

  context 'failure' do
    before { subject.call }

    context 'product is not found' do
      let(:product) { nil }

      it 'returns error' do
        expect(subject.error_key).to eq 'wrong_product'
        expect(subject.change).to be_nil
        expect(subject.success).to be_falsey
      end
    end

    context 'product is out of stock' do
      let(:product_quantity) { 0 }

      it 'returns error' do
        expect(subject.error_key).to eq 'out_of_stock'
        expect(subject.change).to be_nil
        expect(subject.success).to be_falsey
      end
    end

    context 'product is out of stock' do
      it 'returns error' do
        expect(subject.error_key).to eq 'not_enough_balance'
        expect(subject.change).to be_nil
        expect(subject.success).to be_falsey
      end
    end

    context 'change is not available' do
      let(:product_price) { 4.00 }
      let(:coins) { Coins::Collection.new([coin]) }
      let(:user_coins) { Coins::Collection.new([coin]) }

      it 'returns error' do
        expect(subject.error_key).to eq 'not_enough_change'
        expect(subject.change).to eq user_coins
        expect(subject.success).to be_falsey
      end
    end
  end

  context 'success' do
    let(:product_price) { 2.00 }
    let(:coins) { Coins::Collection.new([coin, coin2, coin3]) }
    let(:user_coins) { Coins::Collection.new([user_coin]) }

    let(:coin_quantity) { 2 }

    let(:coin) do
      Coin.new(
        value: 2.00,
        quantity: 1
      )
    end

    let(:coin2) do
      Coin.new(
        value: 1.00,
        quantity: 5
      )
    end

    let(:coin3) do
      Coin.new(
        value: 5.00,
        quantity: 1
      )
    end

    let(:user_coin) do
      Coin.new(
        value: coin3.value,
        quantity: coin3.quantity
      )
    end

    let(:expected_coins_attributes) do
      [
        { value: coin.value, quantity: 0 },
        { value: coin2.value, quantity: 4 },
        { value: coin3.value, quantity: 1 }
      ]
    end

    let(:expected_change_attributes) do
      [
        { value: coin.value, quantity: 1 },
        { value: coin2.value, quantity: 1 }
      ]
    end

    before { subject.call }

    it 'calculates coins' do
      expect(subject.product.quantity).to eq product_quantity - 1
      expect(subject.coins.map(&:attributes)).to eq expected_coins_attributes
      expect(subject.change.map(&:attributes)).to eq expected_change_attributes
      expect(subject.user_coins).to eq []
      expect(subject.success).to be_truthy
    end
  end
end
