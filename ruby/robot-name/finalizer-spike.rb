class Foo

  @@last_num = 0

  def initialize
    @num = (@@last_num += 1)
    ObjectSpace.define_finalizer(self, self.class.finalize(@num))
  end

  def self.finalize(num)
    proc { puts "Finalized #{num}" }
  end

end

f = Foo.new  # num 1

f = 3
f = "foo"
f = Object
f = nil

puts "starting GC after setting to other values"
puts "  (ideally we'd see a finalizer now!)"

GC.start

f = Foo.new  # num 2

puts "starting GC after setting to a new Foo"

GC.start

puts "exiting"
