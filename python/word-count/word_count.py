from collections import Counter
import re

def count_words(sentence):
    words = re.split(r"[^a-z0-9']", sentence.lower())
    words = map(lambda w : w.strip("'"), [w for w in words if w])
    return Counter(words)
