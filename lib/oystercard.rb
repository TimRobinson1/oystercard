class Oystercard
  attr_reader :balance, :entry_station, :journeys

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journeys = {}
  end

  def top_up(amount)
    raise "Limit of £#{BALANCE_LIMIT} reached" if limit_reached?(amount)
    @balance += amount
  end

  def in_journey?
    !(!@entry_station)
  end

  def touch_in(station)
    raise 'Balance too low to travel' if low_balance?
    @entry_station = station
  end

  def touch_out(end_station)
    record_journey(end_station)
    deduct(MINIMUM_FARE)
    @entry_station = nil
  end

  private

  def limit_reached?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def record_journey(end_station)
    @journeys[@entry_station] = end_station
  end

  def low_balance?
    @balance < MINIMUM_FARE
  end

  def deduct(amount)
    @balance -= amount
  end
end
