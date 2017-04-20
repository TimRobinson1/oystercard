require_relative 'station'
require_relative 'journey'
require_relative 'journey_log'

class Oystercard
  attr_reader :balance, :journey

  BALANCE_LIMIT = 90
  MIN_FARE = 1

  def initialize
    @balance = 0
    @log = JourneyLog.new
  end

  def top_up(amount)
    raise "Limit of £#{BALANCE_LIMIT} reached" if limit_reached?(amount)
    @balance += amount
  end

  def touch_in(station)
    raise 'Balance too low to travel' if low_balance?
    touch_out(nil) if @log.journey
    @log.start(station)
  end

  def touch_out(station)
    @log.finish(station)
    deduct(@log.total_fare)
  end

  def show_history
    @log.journeys
  end

  private

  def limit_reached?(amount)
    @balance + amount > BALANCE_LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end

  def low_balance?
    @balance < MIN_FARE
  end
end
