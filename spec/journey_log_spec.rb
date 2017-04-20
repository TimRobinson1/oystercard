require 'journey_log'

describe JourneyLog do
  subject(:log) { described_class.new }
  let(:station) { double :station }

  context 'basic responses' do
    it { is_expected.to respond_to :start }
    it { is_expected.to respond_to :finish }
    it { is_expected.to respond_to :journeys }
  end

  describe '#start' do
    it 'creates a new journey' do
      log.start(station)
      expect(log.journey).to be_a Journey
    end
  end

  describe '#finish' do
    before do
      allow(station).to receive(:zone).and_return(1)
    end

    it 'removes a finished journey' do
      log.start(station)
      log.finish(station)
      expect(log.journey).to be_nil
    end

    it 'records total fare from journey instance for card reading ease' do
      log.start(station)
      log.finish(station)
      expect(log.total_fare).to eq Journey::MIN_FARE
    end
  end

  describe '#journeys' do
    before do
      allow(station).to receive(:zone).and_return(1)
    end

    it 'starts with an empty history' do
      expect(log.journeys).to be_empty
    end

    it 'holds previous journeys' do
      log.start(station)
      log.finish(station)
      hash = [{:entry_station => station, :exit_station => station}]
      expect(log.journeys).to eq hash
    end
  end
end
