class Gigasecond

  VERSION = 1

  def self.from(start_time)
    start_time + SECONDS_IN_GIGASECOND
  end

  private

  SECONDS_IN_GIGASECOND = 1e9

end
