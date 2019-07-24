def is_isogram(string):
    if not isinstance(string, str): raise ValueError
    alfa_chars = [c for c in string.lower() if c.isalpha()]
    return len(set(alfa_chars)) == len(alfa_chars)
