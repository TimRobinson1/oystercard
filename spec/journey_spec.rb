require 'journey'

describe Journey do

  let(:station) { double :station }
  let(:new_station) { double :new_station }
  subject(:journey) { described_class.new(station) }

  it 'starts with the penalty fare as default' do
    expect(journey.fare).to eq Journey::PENALTY
  end

  it 'correctly records station on initialization' do
    expect(journey.entry_station).to eq station
  end

  describe '#record_journey' do
    it 'returns new finished journey as hash' do
      hash = {:entry_station => station, :exit_station => new_station}
      expect(journey.record(new_station)).to eq hash
    end
  end

  describe '#finish' do
    it 'sets the fare to minimum' do
      journey.finish(station)
      expect(journey.fare).to eq Journey::MIN_FARE
    end
  end

  describe '#underway?' do
    it 'returns boolean value based on whether a journey is active or not' do
      journey.finish(station)
      expect(journey.underway?).to eq false
    end
  end
end
