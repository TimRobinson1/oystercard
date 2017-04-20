class Journey
  attr_reader :entry_station, :exit_station, :fare

  MIN_FARE = 1
  PENALTY = 6

  def initialize(station)
    @entry_station = station
    @fare = PENALTY
  end

  def underway?
    !!@entry_station
  end

  def finish(station)
    @fare = MIN_FARE
    record(station)
  end

  def record(station)
    entry, @entry_station = @entry_station, nil
    hash = {:entry_station => entry, :exit_station => station}
  end
end
