require 'spec_helper'

RSpec.describe Console do
  context '#initialize' do
    subject { described_class.new }

    it 'run data loader' do
      expect(DataLoader).to receive(:load).and_call_original
      subject
    end

    it 'load products' do
      expect(subject.instance_variable_get(:@products).all? { |object| object.is_a?(Product) })
        .to be_truthy
    end

    it 'load coins' do
      expect(subject.instance_variable_get(:@coins).all? { |object| object.is_a?(Coin) })
        .to be_truthy
    end
  end
end
