class Oystercard
  attr_reader :balance

  BALANCE_LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise "Limit of £#{BALANCE_LIMIT} reached" if limit_reached?(amount)
    @balance += amount
  end

  def in_journey?
    @in_use
  end

  def touch_in
    raise 'Balance too low to travel' if low_balance?
    @in_use = true
  end

  def touch_out
    @in_use = false
    deduct(MINIMUM_FARE)
  end

  private

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
