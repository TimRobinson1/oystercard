require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }

  it { is_expected.to respond_to :balance }
  it { is_expected.to respond_to :top_up }

  it 'has a starting balance of 0' do
    expect(card.balance).to eq 0
  end

  describe '#top_up' do
    it 'can add to the balance' do
      card.top_up(10)
      expect(card.balance).to eq 10
    end
  end
end
