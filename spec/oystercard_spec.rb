require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }

  it { is_expected.to respond_to :balance }
  it { is_expected.to respond_to :top_up }
  it { is_expected.to respond_to :deduct }
  it { is_expected.to respond_to :in_journey? }

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

  describe '#deduct' do
    it 'should remove correct amount from balance' do
      card.top_up(80)
      card.deduct(10)
      expect(card.balance).to eq 70
    end
  end

  describe '#in_journey?' do
    it 'returns false when not in use' do
      expect(card.in_journey?).to eq false
    end
  end

  describe '#touch_in' do
    it 'sets journey status to true' do
      card.touch_in
      expect(card).to be_in_journey
    end
  end

  describe '#touch_out' do
    it 'sets journey status to false' do
      card.touch_in
      card.touch_out
      expect(card).not_to be_in_journey
    end
  end
end
