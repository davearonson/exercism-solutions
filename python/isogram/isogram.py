def is_isogram(string):
    if not isinstance(string, str): raise ValueError
    alfa_chars = filter(str.isalpha, string.lower())
    return len(set(alfa_chars)) == len(alfa_chars)
