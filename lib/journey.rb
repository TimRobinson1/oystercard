class Journey
  attr_reader :entry_station, :entry_zone

  def initialize(entry_station, entry_zone)
    @entry_station = entry_station
    @entry_zone = entry_zone
  end
end
