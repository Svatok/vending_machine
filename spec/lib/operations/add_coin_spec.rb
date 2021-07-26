require 'spec_helper'

RSpec.describe Operations::AddCoin do
  subject { described_class.new(value: value, user_coins: user_coins, coins: coins) }

  let(:coin) do
    Coin.new(
      value: 5.00,
      quantity: rand(1..5)
    )
  end

  let(:coins) { Coins::Collection.new }
  let(:user_coins) { Coins::Collection.new }
  let(:value) { coin.value }

  context 'failure' do
    before { subject.call }

    context 'coin is not found' do
      it 'returns error' do
        expect(subject.error_key).to eq 'coin_not_found'
        expect(subject.success).to be_falsey
      end
    end
  end

  context 'success' do
    let!(:new_quantity) { coin.quantity + 1 }
    let(:coins) { Coins::Collection.new([coin]) }
    let(:user_coin) do
      Coin.new(
        value: coin.value,
        quantity: 1
      )
    end

    before { subject.call }

    it 'calculates coins' do
      expect(subject.coins.map(&:quantity)).to eq [new_quantity]
      expect(subject.user_coins.map(&:attributes)).to eq [user_coin.attributes]
      expect(subject.success).to be_truthy
    end

    context 'existed user coin' do
      let(:user_coins) { Coins::Collection.new([user_coin]) }

      it 'calculates coins' do
        expect(subject.coins.map(&:quantity)).to eq [new_quantity]
        expect(subject.user_coins.map(&:attributes)).to eq [user_coin.attributes]
        expect(subject.success).to be_truthy
      end
    end
  end
end
