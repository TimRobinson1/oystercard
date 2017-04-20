require 'journey'

describe Journey do

  let(:station) { double :station }
  let(:other_station) { double :other_station }
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
    before do
      allow(station).to receive(:zone).and_return(1)
    end

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

  describe '#fare' do
    it 'calculates the fare for zone 1 to zone 1' do
      allow(station).to receive(:zone).and_return(1)
      allow(other_station).to receive(:zone).and_return(1)
      journey.start(station)
      journey.finish(other_station)
      expect(journey.fare).to eq 1
    end

    it 'calculates the fare for zone 6 to zone 1' do
      allow(station).to receive(:zone).and_return(6)
      allow(other_station).to receive(:zone).and_return(1)
      journey.start(station)
      journey.finish(other_station)
      expect(journey.fare).to eq 6
    end

    it 'calculates the fare for zone 1 to zone 2' do
      allow(station).to receive(:zone).and_return(2)
      allow(other_station).to receive(:zone).and_return(1)
      journey.start(station)
      journey.finish(other_station)
      expect(journey.fare).to eq 2
    end

    it 'calculates the fare for zone 6 to zone 5' do
      allow(station).to receive(:zone).and_return(6)
      allow(other_station).to receive(:zone).and_return(5)
      journey.start(station)
      journey.finish(other_station)
      expect(journey.fare).to eq 2
    end
  end
end
