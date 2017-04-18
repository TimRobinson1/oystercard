class Journey
  attr_reader :entry_station, :entry_zone
  attr_writer :entry_station

  def initialize(entry_station, entry_zone)
    @entry_station = entry_station
    @entry_zone = entry_zone
  end
end
