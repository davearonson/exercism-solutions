import pytest

from matrix import Matrix


# First some fairly normal tests:

class TestWith3x3Matrix:

    matrix = Matrix("1 2 3\n4 5 6\n7 8 9")

    def test_extract_first_col(self):
        assert self.matrix.column(1) == [1, 4, 7]

    def test_extract_first_row(self):
        assert self.matrix.row(1) == [1, 2, 3]

    def test_extract_middle_col(self):
        assert self.matrix.column(2) == [2, 5, 8]

    def test_extract_middle_row(self):
        assert self.matrix.row(2) == [4, 5, 6]

    def test_extract_last_col(self):
        assert self.matrix.column(3) == [3, 6, 9]

    def test_extract_last_row(self):
        assert self.matrix.row(3) == [7, 8, 9]


# make sure it works with non-rectangular matrix

class TestWith2x3Matrix:

    matrix = Matrix("1 2\n3 4\n5 6")

    def test_extract_first_row(self):
        assert self.matrix.row(1) == [1, 2]

    def test_extract_middle_row(self):
        assert self.matrix.row(2) == [3, 4]

    def test_extract_last_row(self):
        assert self.matrix.row(3) == [5, 6]

    def test_extract_first_col(self):
        assert self.matrix.column(1) == [1, 3, 5]

    def test_extract_last_col(self):
        assert self.matrix.column(2) == [2, 4, 6]


# make sure it works with matrix as skinny as possible

class TestWith1x3Matrix:

    matrix = Matrix("1\n2\n3")

    def test_extract_first_row(self):
        assert self.matrix.row(1) == [1]

    def test_extract_middle_row(self):
        assert self.matrix.row(2) == [2]

    def test_extract_last_row(self):
        assert self.matrix.row(3) == [3]

    def test_extract_col(self):
        assert self.matrix.column(1) == [1, 2, 3]


# make sure it works with matrix as short as possible

class TestWith3x1Matrix:

    matrix = Matrix("1 2 3")

    def test_extract_row(self):
        assert self.matrix.row(1) == [1, 2, 3]

    def test_extract_first_col(self):
        assert self.matrix.column(1) == [1]

    def test_extract_middle_col(self):
        assert self.matrix.column(2) == [2]

    def test_extract_last_col(self):
        assert self.matrix.column(3) == [3]


# make sure it works with matrix as small as possible

class TestWith1x1Matrix:

    matrix = Matrix("1")

    def test_extract_row(self):
        assert self.matrix.row(1) == [1]

    def test_extract_col(self):
        assert self.matrix.column(1) == [1]


# make sure it works with mixed width numbers

class TestWithMixedWidth3x3Matrix:

    matrix = Matrix("1 23 456\n789 10 2\n34 5678 90120")

    def test_extract_first_col(self):
        assert self.matrix.column(1) == [1, 789, 34]

    def test_extract_first_row(self):
        assert self.matrix.row(1) == [1, 23, 456]

    def test_extract_middle_col(self):
        assert self.matrix.column(2) == [23, 10, 5678]

    def test_extract_middle_row(self):
        assert self.matrix.row(2) == [789, 10, 2]

    def test_extract_last_col(self):
        assert self.matrix.column(3) == [456, 2, 90120]

    def test_extract_last_row(self):
        assert self.matrix.row(3) == [34, 5678, 90120]


# Now some bulletproofing.  Not necessary for normal academic exercise, but I'm
# using Exercism to lead some juniors through learning Python and testing, and
# we're doing security-related software so we should have more than usual.


class TestWithInvalidIndex:

    matrix = Matrix("1 2\n3 4")

    def test_extract_row_too_high(self):
        assert self.matrix.row(3) is None

    def test_extract_row_too_low(self):
        assert self.matrix.row(0) is None

    def test_extract_col_too_high(self):
        assert self.matrix.column(3) is None

    def test_extract_col_too_low(self):
        assert self.matrix.column(0) is None


class TestWithEmptyMatrix:

    matrix = Matrix("")

    def test_extract_row(self):
        assert self.matrix.row(1) is None

    def test_extract_col(self):
        assert self.matrix.column(1) is None

    # Having these return [] would be OK too, so long as they're
    # consistent between them.


# NOT BOTHERING TO TEST:
# - matrices that are not rectangular/square
# - numbers other than positive integers
# - scientific notation
# - non-numbers, tho it should be easy to adapt this to any unbroken string
# - matrices of multiple blank rows (e.g, "\n\n\n" -> [[],[],[],[]]
