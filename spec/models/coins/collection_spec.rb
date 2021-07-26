require 'spec_helper'

RSpec.describe Coins::Collection do
  let(:coin1) { Coin.new(value: rand(1.00..2.00), quantity: rand(1..5)) }
  let(:coin2) { Coin.new(value: coin1.value + 1.00, quantity: rand(1..5)) }

  subject { described_class.new([coin1, coin2]) }

  it '#find_by_value' do
    expect(subject.find_by_value(coin2.value)).to eq coin2
  end

  it '#balance' do
    expect(subject.balance)
      .to eq(coin1.value * coin1.quantity + coin2.value * coin2.quantity)
  end
end
