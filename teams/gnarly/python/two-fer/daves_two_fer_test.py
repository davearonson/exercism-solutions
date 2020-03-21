import pytest

from two_fer import two_fer

one_for_you = "One for you, one for me."

# first, normal cases

def test_no_name():
    assert two_fer() == one_for_you

def test_given_name():
    assert two_fer("Alice") == "One for Alice, one for me."


# now, likely errors -- a caller may think "no name" is an empty string,
# or None, rather than not passing an argument at all.

def test_given_name_with_spaces_around():
    assert two_fer("   Alice        ") == "One for Alice, one for me."

def test_empty_name():
    assert two_fer("") == one_for_you

def test_none_name():
    assert two_fer(None) == one_for_you


# and now, some things that some jerk might do deliberately:

def test_blank_name():
    assert two_fer(" ") == one_for_you

def test_several_blanks_name():
    assert two_fer("     ") == one_for_you

def test_newline_name():
    assert two_fer("\n") == one_for_you

def test_number_name():
    assert two_fer(17) == one_for_you

def test_object_name():
    assert two_fer(object()) == one_for_you


# Did NOT think to test with a DIFFERENT name, as Exercism's suite
# does, to ensure that it's not just keying off of whether the name is
# present.  We could even cover both ideas in one with a random name,
# or to go really overboard, a long stretch of property testing.
