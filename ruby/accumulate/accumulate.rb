class Array
  def accumulate(&block)
    # delegate to elsewhere to minimize pollution of Array
    Accumulator::accumulate(self, &block)
  end
end

module Accumulator
  def self.accumulate(array, &block)
    [].tap { |results|
      array.each { |item| results << yield(item) }
    }
  end
end
