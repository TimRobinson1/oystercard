require 'oystercard'

describe Oystercard do
  subject(:card) { described_class.new }
  let(:station) { double(:station) }
  let(:exit_station) { double(:station) }

  it { is_expected.to respond_to :balance }
  it { is_expected.to respond_to :top_up }
  it { is_expected.to respond_to :in_journey? }

  context 'starts with' do
    it 'a balance of 0' do
      expect(card.balance).to eq 0
    end

    it 'with no journeys' do
      expect(card.journeys).to be_empty
    end
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

  describe '#in_journey?' do
    it 'returns false when not in use' do
      expect(card.in_journey?).to eq false
    end
  end

  describe '#touch_in' do
    it 'sets journey status to true' do
      card.top_up(30)
      card.touch_in(station)
      expect(card).to be_in_journey
    end

    it 'raises error if current balance is below minimum' do
      message = 'Balance too low to travel'
      expect { card.touch_in(station) }.to raise_error message
    end

    it 'records entry station' do
      card.top_up(30)
      card.touch_in(station)
      expect(card.entry_station).to eq station
    end
  end

  describe '#touch_out' do
    before do
      card.top_up(30)
      card.touch_in(station)
    end

    it 'sets journey status to false' do
      card.touch_out(station)
      expect(card).not_to be_in_journey
    end

    it 'removes minimum fare from balance' do
      expect { card.touch_out(station) }.to change { card.balance }.by(-1)
    end

    it 'sets entry station to nil' do
      card.touch_out(station)
      expect(card.entry_station).to eq nil
    end

    it 'records entry and exit stations as one journey' do
      card.touch_out(exit_station)
      hash = { station => exit_station }
      expect(card.journeys).to eq hash
    end
  end
end
