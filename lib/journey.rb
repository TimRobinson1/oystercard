class Journey
  attr_reader :entry_station, :exit_station, :travel_fare

  MIN_FARE = 1
  PENALTY = 6

  def initialize
    @entry_station = nil
    @exit_station = nil
  end

  def start(station = nil)
    @entry_station = station
  end

  def in_progress?
    !!@entry_station
  end

  def finish(station = nil)
    @exit_station = station
    hash = {:entry_station => @entry_station, :exit_station => station}
  end

  def fare
    return PENALTY if (!@entry_station || !@exit_station)
    MIN_FARE
  end
end
