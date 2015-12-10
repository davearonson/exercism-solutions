class School

  VERSION = 1

  def initialize
    @students = Hash.new() { |hash, grade| hash[grade] = Array.new }
  end

  def add(name, grade)
    @students[grade] << name
  end

  def grade(number)
    @students[number].sort
  end

  def to_h
    {}.tap { |sorted|
      @students.keys.sort.each { |num| sorted[num] = grade(num) }
    }
  end

end
