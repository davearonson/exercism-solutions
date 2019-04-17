# additional test suite written as exercise in what/how to test;
# code should pass both this and Exercism's supplied test suite.

import pytest

from high_scores import HighScores

class Test_scores_access:

    def test_basic(self):
        array = [17, 42, 23, 0]
        assert HighScores(array).scores == array

    def test_alternate(self):
        array = [17, 42, 23, 0, 69]
        assert HighScores(array).scores == array

    def test_with_none(self):
        array = []
        assert HighScores(array).scores == array

    def test_dont_modify_list(self):
        array = [17, 42, 86, 23, 0, 69]
        hs = HighScores(array)
        hs.scores  # don't need to use it
        assert hs.scores == array


class Test_latest_method:

    def test_basic(self):
        array = [17, 42, 23, 0]
        assert HighScores(array).latest() == 0

    def test_alternate(self):
        array = [17, 42, 23, 0, 69]
        assert HighScores(array).latest() == 69

    def test_with_none(self):
        assert HighScores([]).latest() == None

    def test_dont_modify_list(self):
        array = [17, 42, 86, 23, 0, 69]
        hs = HighScores(array)
        hs.latest()  # don't need to use it 
        assert hs.scores == array

class Test_personal_best_method:

    def test_basic(self):
        array = [17, 42, 23, 0]
        assert HighScores(array).personal_best() == 42

    def test_alternate(self):
        array = [17, 69, 42, 23, 0]
        assert HighScores(array).personal_best() == 69

    def test_with_none(self):
        assert HighScores([]).personal_best() == None

    def test_dont_modify_list(self):
        array = [17, 42, 86, 23, 0, 69]
        hs = HighScores(array)
        hs.personal_best()  # don't need to use it 
        assert hs.scores == array

class Test_personal_top_three_method:

    def test_basic(self):
        array = [17, 42, 23, 0, 86, 69]
        assert HighScores(array).personal_top_three() == [86, 69, 42]

    def test_alternate(self):
        array = [17, 42, 23, 72, 86, 69]
        assert HighScores(array).personal_top_three() == [86, 72, 69]

    def test_with_first_place_3_way_tie(self):
        array = [17, 69, 42, 69, 26, 69, 42]
        assert HighScores(array).personal_top_three() == [69, 69, 69]

    def test_with_first_place_2_way_tie(self):
        array = [17, 69, 42, 39, 26, 69, 42]
        assert HighScores(array).personal_top_three() == [69, 69, 42]

    def test_with_second_place_3_way_tie(self):
        array = [17, 69, 42, 69, 86, 69, 42]
        assert HighScores(array).personal_top_three() == [86, 69, 69]

    def test_with_only_three(self):
        array = [42, 86, 69]
        expected = sorted(array, reverse = True)
        assert HighScores(array).personal_top_three() == expected

    def test_with_only_two(self):
        array = [42, 69]
        expected = sorted(array, reverse = True)
        assert HighScores(array).personal_top_three() == expected

    def test_with_only_one(self):
        array = [42]
        assert HighScores(array).personal_top_three() == array

    def test_with_none(self):
        array = []
        assert HighScores(array).personal_top_three() == array

    def test_dont_modify_list(self):
        array = [17, 42, 86, 23, 0, 69]
        hs = HighScores(array)
        hs.personal_top_three()  # don't need to use it 
        assert hs.scores == array
