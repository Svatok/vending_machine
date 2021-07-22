require 'spec_helper'

RSpec.describe DataLoader do
  context '#load' do
    subject { described_class.load }

    it 'load not empty collections' do
      expect(subject.all?(&:empty?)).to be_falsey
    end

    it 'load products' do
      expect(subject.first.all? { |object| object.is_a?(Product) }).to be_truthy
    end

    it 'load coins' do
      expect(subject.last.all? { |object| object.is_a?(Coin) }).to be_truthy
    end
  end
end
