DEFAULT_NAME = "you"

def two_fer(name=DEFAULT_NAME):
    if isinstance(name, str):
        name = name.strip()
        if name == "": name = DEFAULT_NAME
    else:
        # If it's not even a string, just go with the default
        # name.  We COULD skip the "else" and just go with
        # whatever the param's string equivalent is, but I'm
        # being deliberately paranoid, albeit not quite enough
        # to raise an error.  :-)  I'm doing these exercises as
        # part of teaching some juniors to code and test, and we
        # do security software, so all my entries in this series
        # will probably have much more bulletproofing than an
        # academic exercise would justify.
        name = DEFAULT_NAME
    return f"One for {name}, one for me."
