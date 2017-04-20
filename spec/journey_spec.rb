require 'journey'

describe Journey do

  let(:station) { double :station }
  let(:new_station) { double :new_station }
  let(:unstarted_journey) { described_class.new }
  subject(:journey) { described_class.new }

  it 'starts with the penalty fare as default' do
    expect(journey.fare).to eq Journey::PENALTY
  end

  describe '#start' do
    it 'correctly records station on initialization' do
      journey.start(station)
      expect(journey.entry_station).to eq station
    end
  end

  describe '#finish' do
    it 'sets the fare to minimum' do
      journey.start(station)
      journey.finish(station)
      expect(journey.fare).to eq Journey::MIN_FARE
    end
  end

  describe '#in_progress?' do
    it 'should start as false' do
      expect(unstarted_journey.in_progress?).to be false
    end

    it 'should be true after being provided entry station' do
      journey.start(station)
      expect(journey.in_progress?).to be true
    end
  end
end
