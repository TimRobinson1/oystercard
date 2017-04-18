require 'station'

describe Station do
  subject(:station) { described_class.new('Angel', 1) }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :zone }

  it 'returns correct name' do
    expect(station.name).to eq 'Angel'
  end

  it 'returns correct zone' do
    expect(station.zone).to eq 1
  end
end
