class Journey
  attr_reader :entry_station, :entry_zone, :exit_station, :exit_zone

  def initialize(entry_station, entry_zone)
    @entry_station = entry_station
    @entry_zone = entry_zone
  end

  def complete(end_station)
    @exit_zone = end_station.zone
    @exit_station = end_station.name
  end
end
