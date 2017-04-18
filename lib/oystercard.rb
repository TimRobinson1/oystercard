require_relative 'station'
require 'date'

class Oystercard
  attr_reader :balance, :journeys, :journey, :num_journies

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1
  PENALTY = 6

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
    charge_penalty_in if in_journey?
    raise 'Balance too low to travel' if low_balance?
    @journey = Journey.new(station.name, station.zone)
  end

  def touch_out(end_station)
    charge_penalty_out(end_station) unless in_journey?
    @num_journies += 1
    record_journey(end_station)
    deduct(MINIMUM_FARE)
  end

  private

  def limit_reached?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def record_journey(end_station)
    @journey.complete(end_station)
    @journeys[ num_journies ] = [
      journey.entry_station, journey.entry_zone,
      journey.exit_station, journey.exit_zone
    ]
    @journey = nil
  end

  def low_balance?
    @balance < MINIMUM_FARE
  end

  def deduct(amount)
    @balance -= amount
  end

  def charge_penalty_in
    @balance -= PENALTY
    puts "You've didn't touch out! Charged: £#{PENALTY}"
  end

  def charge_penalty_out(station)
    @balance -= PENALTY
    @journey = Journey.new(station.name, station.zone)
    puts "You didn't touch in! Charged: £#{PENALTY+MINIMUM_FARE}"
  end
end
