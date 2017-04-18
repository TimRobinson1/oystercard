require 'journey'

describe Journey do
  subject(:journey) { described_class.new('Old Street', 1) }

  it 'returns correct entry station' do
    expect(journey.entry_station).to eq 'Old Street'
  end

  it 'returns correct entry zone' do
    expect(journey.entry_zone).to eq 1
  end
end
