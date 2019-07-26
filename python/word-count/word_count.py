import re

def count_words(sentence):
    words = re.split(r"[^a-z0-9']", sentence.lower())
    words = filter(lambda w : w, words)
    words = map(lambda w : w.strip("'"), words)
    tally = {}
    for word in words:
        tally[word] = tally[word] + 1 if word in tally else 1
    return tally
