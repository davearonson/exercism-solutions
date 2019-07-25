BASE = "On the {} day of Christmas my true love gave to me: "

DAY_NAMES = [
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth",
    "eleventh",
    "twelfth"
]

VERSES = [
    "a Partridge in a Pear Tree.",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"
]

def recite(start_verse, end_verse):
    if not isinstance(start_verse, int): raise ValueError
    if not isinstance(end_verse, int): raise ValueError
    return [verse(n) for n in range(start_verse - 1, end_verse)]

def verse(n):
    middle = ", ".join(VERSES[n:0:-1]) + ", and " if n > 0 else ""
    return BASE.format(DAY_NAMES[n]) + middle + VERSES[0]
