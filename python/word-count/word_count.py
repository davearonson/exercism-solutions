from collections import Counter
import re

def count_words(sentence):
    words = re.split(r"[^a-z0-9']", sentence.lower())
    words = filter(lambda w : w, words)
    words = map(lambda w : w.strip("'"), words)
    return Counter(words)
