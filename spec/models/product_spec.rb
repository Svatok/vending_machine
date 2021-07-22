require 'spec_helper'

RSpec.describe Product do
  subject { described_class.new(attributes) }

  context 'new instance' do
    let(:attributes) do
      {
        name: FFaker::Product.product_name,
        price: rand(1.00..2.00),
        quantity: rand(1..5)
      }
    end

    it '#name' do
      expect(subject.name).to eq(attributes[:name])
    end

    it '#price' do
      expect(subject.price).to eq(attributes[:price])
    end

    it '#quantity' do
      expect(subject.quantity).to eq(attributes[:quantity])
    end
  end
end
