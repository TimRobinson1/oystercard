require_relative 'station'
require 'date'

class Oystercard
  attr_reader :balance, :entry_station, :journeys, :journey, :num_journies

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journeys = {}
    @journey = nil
    @num_journies = 0
  end

  def top_up(amount)
    raise "Limit of £#{BALANCE_LIMIT} reached" if limit_reached?(amount)
    @balance += amount
  end

  def in_journey?
    !!@journey
  end

  def touch_in(station)
    raise 'Balance too low to travel' if low_balance?
    @entry_station = station
    @journey = Journey.new(station.name, station.zone)
  end

  def touch_out(end_station)
    record_journey(end_station)
    deduct(MINIMUM_FARE)
  end

  private

  def limit_reached?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def record_journey(end_station)
    @num_journies += 1
    @journeys[ num_journies ] = [ journey.entry_station, journey.entry_zone ]
    @journey = nil
  end

  def low_balance?
    @balance < MINIMUM_FARE
  end

  def deduct(amount)
    @balance -= amount
  end
end
