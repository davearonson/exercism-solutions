import pytest

from raindrops import raindrops


# basic functionality:

def test_multiple_of_none_becomes_string():
    assert raindrops(1) == "1"

def test_3_is_pling():
    assert raindrops(6) == "Pling"

def test_5_is_plang():
    assert raindrops(5) == "Plang"

def test_7_is_plong():
    assert raindrops(7) == "Plong"

def test_3_and_5_make_plingplang():  # not plangpling
    assert raindrops(30) == "PlingPlang"

def test_3_and_7_make_plingplong():  # not plongpling
    assert raindrops(42) == "PlingPlong"

def test_5_and_7_make_plangplong():  # not plongplang
    assert raindrops(70) == "PlangPlong"

def test_all_together_make_plingplangplong():
    assert raindrops(210) == "PlingPlangPlong"  # not any other order


# light bulletproofing:

def test_raising_error_with_non_integer_input():
    with pytest.raises(ValueError) as exception_info:
        raindrops("blah")
        assert False, "Failed to raise an error with a non-integer input!"
    assert True


# stuff we may want to consider okay, or not:

# we could possibly consider N.0 equivalent to N, but for now, no
def test_raising_error_with_int_valued_float():
    with pytest.raises(ValueError) as exception_info:
        raindrops(4.0)
        assert False, "Failed to raise an error with a rounded float!"
    assert True

def test_works_with_zero():
    assert raindrops(0) == "PlingPlangPlong"

def test_works_with_negative_non_multiples():
    assert raindrops(-4) == "-4"

def test_works_with_negative_multiples_of_one_trigger():
    assert raindrops(-50) == "Plang"

def test_works_with_negative_multiples_of_two_triggers():
    assert raindrops(-42) == "PlingPlong"

def test_works_with_negative_multiples_of_all():
    assert raindrops(-210) == "PlingPlangPlong"
