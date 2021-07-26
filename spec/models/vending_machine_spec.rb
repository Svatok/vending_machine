require 'spec_helper'

RSpec.describe VendingMachine do
  subject { described_class.new(coins: coins, products: products) }

  let(:product) do
    Product.new(
      name: FFaker::Product.product_name,
      price: rand(1.00..2.00),
      quantity: rand(1..5)
    )
  end

  let(:coin) do
    Coin.new(
      value: 5.00,
      quantity: rand(1..5)
    )
  end

  let(:products) { [product] }
  let(:coins) { [] }

  context '#add_coin' do
    let(:operation) do
      instance_double(
        Operations::AddCoin,
        success: success,
        call: true,
        coins: [coin],
        user_coins: [coin]
      )
    end
    let(:success) { true }

    before do
      expect(Operations::AddCoin)
        .to receive(:new).with(
          coins: coins, user_coins: be_kind_of(Coins::Collection), value: coin.value
        ) { operation }
    end

    it 'calls operation' do
      expect(operation).to receive(:call) { true }
      subject.add_coin(coin.value)
    end

    context 'success operation' do
      it 'updates coins' do
        expect { subject.add_coin(coin.value) }
          .to change { subject.user_coins }
          .from([]).to([coin]).and change { subject.coins }
          .from([]).to([coin])
      end
    end

    context 'success operation' do
      let(:success) { false }

      it 'does not update coins' do
        expect { subject.add_coin(coin.value) }
          .to not_change { subject.user_coins }
          .and(not_change { subject.coins })
      end
    end
  end

  context '#select_product' do
    let(:operation) do
      instance_double(
        Operations::SelectProduct,
        success: success,
        call: true,
        coins: [coin],
        user_coins: [coin],
        change: change_coins
      )
    end
    let(:success) { true }
    let(:change_coins) { [coin] }

    before do
      expect(Operations::SelectProduct)
        .to receive(:new).with(
          product: product, coins: coins, user_coins: be_kind_of(Coins::Collection)
        ) { operation }
    end

    it 'calls operation' do
      expect(operation).to receive(:call) { true }
      subject.select_product(1)
    end

    context 'change is present' do
      it 'updates coins' do
        expect { subject.select_product(1) }
          .to change { subject.user_coins }
          .from([]).to([coin]).and change { subject.coins }
          .from([]).to([coin])
      end
    end

    context 'change is not present' do
      let(:change_coins) { nil }

      it 'does not update coins' do
        expect { subject.select_product(1) }
          .to not_change { subject.user_coins }
          .and(not_change { subject.coins })
      end
    end
  end

  context '#user_balance' do
    before { subject.instance_variable_set(:@user_coins, Coins::Collection.new([coin])) }

    it 'returns balance' do
      expect(subject.user_balance).to eq(coin.value * coin.quantity)
    end
  end
end
