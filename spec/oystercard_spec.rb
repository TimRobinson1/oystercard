require 'oystercard'
require 'journey'
require 'date'

describe Oystercard do

  subject(:card) { described_class.new }
  let(:station) { double(:station) }
  let(:exit_station) { double(:station) }
  let(:journey) { double(:journey) }

  context 'starts' do

    it 'with a balance of 0' do
      expect(card.balance).to eq 0
    end

    it 'with no journeys' do
      expect(card.journeys).to be_empty
    end

  end

  describe '#top_up' do
    it 'adds to the balance' do
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

    before do
      card.top_up(30)
      allow(station).to receive_messages(:name => "Old Street", :zone => 1)
    end

    it 'returns false when not in use' do
      expect(card.in_journey?).to eq false
    end

    it 'returns true when in use' do
      card.top_up(45)
      card.touch_in(station)
      expect(card.in_journey?).to eq true
    end

  end

  describe '#touch_in' do

    before do
      card.top_up(30)
      allow(station).to receive_messages(:name => "Old Street", :zone => 1)
      allow(exit_station).to receive_messages(:name => "Aldgate", :zone => 2)
    end

    it 'sets journey status to true' do
      card.touch_in(station)
      expect(card).to be_in_journey
    end

    it 'creates a new journey object' do
      expect(card.touch_in(station)).to be_kind_of Journey
    end

    it 'raises error if current balance is below minimum' do
      30.times do card.touch_in(station) ; card.touch_out(exit_station) end
      message = 'Balance too low to travel'
      expect { card.touch_in(station) }.to raise_error message
    end

    it 'charges penalty when touching in twice consecutively' do
      card.touch_in(station)
      expect{card.touch_in(station)}.to change{card.balance}.by(-Oystercard::PENALTY)
    end
  end

  describe '#touch_out' do

    before do
      card.top_up(30)
      allow(station).to receive_messages(:name => "Old Street", :zone => 1)
      allow(journey).to receive_messages(
      :entry_station => "Old Street", :entry_zone => 1, 
      :exit_station => "Aldgate East", :exit_zone => 3)
      allow(exit_station).to receive_messages(:name => "Aldgate East", :zone => 3)
      card.touch_in(station)
    end

    it 'sets journey status to false' do
      card.touch_out(station)
      expect(card).not_to be_in_journey
    end

    it 'removes minimum fare from balance' do
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'sets entry station to nil' do
      card.touch_out(station)
      expect(card.in_journey?).to be false
    end

    it 'records entry and exit stations as one journey' do
      allow(exit_station).to receive_messages(:name => "Aldgate East", :zone => 3)
      card.touch_in(station)
      card.touch_out(exit_station)
      hash = { card.num_journies => [ journey.entry_station, journey.entry_zone, journey.exit_station, journey.exit_zone ] }
      expect(card.journeys).to eq hash
    end

    it 'charges penalty when touching out without touching in' do
      card.touch_out(station)
      expect { card.touch_out(station) }.to change { card.balance }.by(-Oystercard::PENALTY - Oystercard::MINIMUM_FARE)
    end

  end
end
