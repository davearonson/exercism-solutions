class Animal
  ATTRS = %i(name comment reason catch_extra)
  attr_accessor *ATTRS
  def initialize(options)
    options.each { |key, val| self.send("#{key}=".to_s, val) }
  end
end


class FoodChain

  VERSION = 2

  def self.song
    ANIMALS.map { |animal| stanza_for(animal) }.join("\n\n")
  end

  private

  ANIMALS = [
    Animal.new(name: "fly",
               # note no comment, but a special reason!
               reason: "I don't know why she swallowed the fly."\
                       " Perhaps she'll die."),
    Animal.new(name: "spider",
               comment:
                 "It wriggled and jiggled and tickled inside her.",
               # note another special item here:
               catch_extra:
                 " that wriggled and jiggled and tickled inside her"),
    Animal.new(name: "bird",
               comment: "How absurd to swallow a bird!"),
    Animal.new(name: "cat",
               comment: "Imagine that, to swallow a cat!"),
    Animal.new(name: "dog",
               comment: "What a hog, to swallow a dog!"),
    Animal.new(name: "goat",
               comment: "Just opened her throat and swallowed a goat!"),
    Animal.new(name: "cow",
               comment: "I don't know how she swallowed a cow!"),
    Animal.new(name: "horse",
               comment: "She's dead, of course!\n")
  ]

  def self.reason_line_for_animal(animal)
    animal.reason || begin
      prev = ANIMALS[ANIMALS.index(animal) - 1]
      "She swallowed the #{animal.name} to catch the #{prev.name}"\
        "#{prev.catch_extra}."
    end
  end

  def self.reason_lines_for_stanza(animal)
    return [] if animal == ANIMALS.last  # special case
    # could also do take_while not stanza_animal, and also push that
    ANIMALS[0, ANIMALS.index(animal) + 1].reverse.map { |a|
      reason_line_for_animal(a) }
  end

  def self.stanza_for(animal)
    # not worrying about "a" vs. "an"...
    (["I know an old lady who swallowed a #{animal.name}.",
       animal.comment].
       compact +
       reason_lines_for_stanza(animal)).join("\n")
  end

end
