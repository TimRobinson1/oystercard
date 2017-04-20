class JourneyLog
  attr_reader :total_fare, :journey

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @history = []
  end

  def start(station)
    current_journey.start(station)
  end

  def finish(station)
    @history << current_journey.finish(station)
    @total_fare = current_journey.fare
    @journey = nil
  end

  def journeys
    @history
  end

  private

  def current_journey
    @journey ||= @journey_class.new
  end

end
