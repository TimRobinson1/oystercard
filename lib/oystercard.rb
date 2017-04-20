require_relative 'station'
require_relative 'journey'

class Oystercard
  attr_reader :balance, :journey, :history

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1
  PENALTY = 6

  def initialize
    @balance = 0
    @journey = nil
    @history = []
  end

  def top_up(amount)
    raise "Limit of £#{BALANCE_LIMIT} reached" if limit_reached?(amount)
    @balance += amount
  end

  def touch_in(station)
    raise 'Balance too low to travel' if low_balance?
    journey ? invalid_in(station) : @journey = Journey.new(station)
  end

  def touch_out(end_station)
    journey ? valid_out(end_station) : invalid_out(end_station)
  end

  private

  def valid_out(end_station)
    @history << journey.finish(end_station)
    message = "Trip costed £#{journey.fare}"
    deduct(journey.fare)
    @journey = nil
    message
  end

  def invalid_out(end_station)
    @journey = Journey.new(nil)
    @history << journey.record(end_station)
    message = "Fine incurred. Trip costed £#{journey.fare}"
    deduct(journey.fare)
    @journey = nil
    message
  end

  def invalid_in(station)
    @history << journey.record(nil)
    message = "Fine incurred. Trip costed £#{journey.fare}"
    deduct(journey.fare)
    @journey = Journey.new(station)
    message
  end

  def limit_reached?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def low_balance?
    @balance < MINIMUM_FARE
  end

  def deduct(amount)
    @balance -= amount
  end
end
