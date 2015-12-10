class Utterance

  def initialize(string)
    @string = string
  end

  def type
    # check shout before question because a shouted question counts as a
    # shout, not a question.  note that even if it ends in "!", it's not
    # a shout unless all letters are uppercase.  (ignore non-letters.)
    if all_chars_uppercase
      :shout
    elsif @string.end_with? "?"
      :question 
    elsif ! @string.strip.empty?
      :statement
    else
      :empty
    end
  end

  def all_chars_uppercase
    @string =~ /[[:upper:]]/ && @string !~ /[[:lower]]/
  end

end


class Bob

  def hey(utterance)
    type = Utterance.new(utterance).type
    type = :unknown unless RESPONSES.has_key? type
    RESPONSES[type]
  end

  private

  RESPONSES = {
    statement: "Whatever.",
    shout:     "Whoa, chill out!",
    question:  "Sure.",
    empty:     "Fine. Be that way!",
    unknown:   "Huh?"
  }

end
