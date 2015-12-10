class PhoneNumber
  
  def initialize(str)
    @number = canonical(str)
  end

  def area_code
    @number[0,3]
  end

  def exchange
    @number[3,3]
  end

  def number
    @number
  end

  def rest_of_number
    @number[6,4]
  end

  def to_s
    "(#{area_code}) #{exchange}-#{rest_of_number}"
  end

  private

  # TODO: clean this up....
  def canonical(number)
    digits = number.gsub(/[^\d]/, "")
    if digits.length == 10
      digits
    elsif digits.length == 11 && digits.chars.first == "1"
      digits.gsub!(/^1/, "")
    else
      # wtf, instead of storing an invalid number,
      # shouldn't we be raising an exception or something?
      "0000000000"
    end
  end

end
