noises = ((3, "Pling"), (5, "Plang"), (7, "Plong"))

def convert(number):
    # just a little bulletproofing
    if not isinstance(number, int): raise ValueError
    result = [noise for trigger, noise in noises if number % trigger == 0]
    return "".join(result) if result else str(number)
