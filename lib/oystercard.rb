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
    touch_out(nil) if @journey
    @journey = Journey.new(station)
  end

  def touch_out(station)
    touch_in(nil) unless @journey
    @history << @journey.finish(station)
    journey_reset
  end

  private

  def limit_reached?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end

  def journey_reset
    deduct(@journey.fare)
    @journey = nil
    "Journey complete."
  end

  def low_balance?
    @balance < MINIMUM_FARE
  end
end
