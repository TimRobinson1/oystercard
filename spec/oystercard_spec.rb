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

    describe 'raises error' do

      it 'when increased over limit' do
        message = "Limit of £#{Oystercard::BALANCE_LIMIT} reached"
        expect { card.top_up(91) }.to raise_error message
      end

      it 'when added incrementally over limit' do
        message = "Limit of £#{Oystercard::BALANCE_LIMIT} reached"
        card.top_up(40)
        card.top_up(45)
        expect { card.top_up(10) }.to raise_error message
      end
    end
  end
end
