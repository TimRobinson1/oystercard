require 'journey'

describe Journey do
  subject(:journey) { described_class.new('Old Street', 1) }
  let(:station) { double :station }

  it 'returns correct entry station' do
    expect(journey.entry_station).to eq 'Old Street'
  end

  it 'returns correct entry zone' do
    expect(journey.entry_zone).to eq 1
  end

  it 'records exit zone' do
    allow(station).to receive_messages(:name => "Old Street", :zone => 1)
    journey.complete(station)
    expect(journey.exit_zone).to eq 1
  end

  it 'records exit station' do
    allow(station).to receive_messages(:name => "Old Street", :zone => 1)
    journey.complete(station)
    expect(journey.exit_station).to eq 'Old Street'
  end
end
