import pytest

import hamming

# basic functionality

def test_same_singles_means_distance_zero():
    assert hamming.distance("G", "G") == 0

def test_different_singles_means_distance_one():
    assert hamming.distance("G", "C") == 1

# not much value in testing twos

def test_same_three_means_distance_zero():
    assert hamming.distance("GCA", "GCA") == 0

def test_three_different_at_start_means_distance_one():
    assert hamming.distance("GCA", "CCA") == 1

def test_three_different_in_middle_means_distance_one():
    assert hamming.distance("GCA", "GGA") == 1

def test_three_different_at_end_means_distance_one():
    assert hamming.distance("GCA", "GCG") == 1

def test_three_same_only_at_start_means_distance_two():
    assert hamming.distance("GCA", "GTG") == 2

def test_three_same_only_in_middle_means_distance_two():
    assert hamming.distance("GCA", "TCC") == 2

def test_three_same_only_at_end_means_distance_two():
    assert hamming.distance("GCA", "CGA") == 2

def test_different_three_means_distance_three():
    assert hamming.distance("GCA", "CAG") == 3

# going up to three should be enough to prove the general case

# light bulletproofing: valid edge case

def test_two_empty_means_distance_zero():
    assert hamming.distance("", "") == 0

# medium bulletproofing: invalid edge cases and likely errors

def test_raises_with_msg_if_first_shorter():
    with pytest.raises(ValueError) as exception_info:
        hamming.distance("GC", "TGA")
    assert hamming.LENGTH_MISMATCH_MESSAGE in str(exception_info)

def test_raises_with_msg_if_second_shorter():
    with pytest.raises(ValueError) as exception_info:
        hamming.distance("GCA", "TG")
    assert hamming.LENGTH_MISMATCH_MESSAGE in str(exception_info)

def test_raises_with_msg_if_first_has_invalid_base():
    with pytest.raises(ValueError) as exception_info:
        hamming.distance("CAGE", "CAGT")
    assert hamming.INVALID_BASE_MESSAGE in str(exception_info)

def test_raises_with_msg_if_second_has_invalid_base():
    with pytest.raises(ValueError) as exception_info:
        hamming.distance("CAGT", "CAGE")
    assert hamming.INVALID_BASE_MESSAGE in str(exception_info)

# heavy bulletproofing: invalid cases not likely from innocent error

def test_raises_with_msg_if_first_not_string():
    with pytest.raises(ValueError) as exception_info:
        hamming.distance(3, "TG")
    assert hamming.NOT_STRING_MESSAGE in str(exception_info)

def test_raises_with_msg_if_second_not_string():
    with pytest.raises(ValueError) as exception_info:
        hamming.distance("TG", 3)
    assert hamming.NOT_STRING_MESSAGE in str(exception_info)
