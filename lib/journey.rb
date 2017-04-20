class Journey
  attr_reader :entry_station, :exit_station, :fare

  MIN_FARE = 1
  PENALTY = 6

  def initialize(station)
    @entry_station = station
    @fare = PENALTY
  end

  def finish(station)
    @fare = MIN_FARE
    record(station)
  end

  def record(station)
    hash = {:entry_station => @entry_station, :exit_station => station}
  end
end
