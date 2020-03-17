# deliberately done in pytest style rather than unittest style,
# as that's what i'm choosing for the team at work, as there's
# so much less abstruse boilerplate.

import pytest

# "import hello_world" also works, but then you have to call
# hello_world.hello, not just hello.
# useful as namespacing when needed though.
import hello_world

def test_hello_world():
    assert hello_world.hello() == "Hello, World!"
