from collections import Counter
import re

def count_words(sentence):
    words = re.split(r"[^a-z0-9']", sentence.lower())
    words = map(lambda w : w.strip("'"), words)
    words = filter(lambda w : w, words)
    return Counter(words)
