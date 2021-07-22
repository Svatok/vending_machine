require 'spec_helper'

RSpec.describe Coin do
  subject { described_class.new(attributes) }

  context 'new instance' do
    let(:attributes) do
      {
        value: rand(1.00..2.00),
        quantity: rand(1..5)
      }
    end

    it '#name' do
      expect(subject.value).to eq(attributes[:value])
    end

    it '#value' do
      expect(subject.quantity).to eq(attributes[:quantity])
    end
  end
end
