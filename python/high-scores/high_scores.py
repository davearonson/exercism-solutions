class HighScores:

    def __init__(self, scores):
        # could possibly insert some bulletproofing here to make sure that
        # scores is an array of non-negative integers -- not bothering now.
        self.scores = scores

    def latest(self):
        return self.scores[-1] if self.scores else None

    def personal_best(self):
        return max(self.scores) if self.scores else None

    def personal_top_three(self):
        return sorted(self.scores, reverse=True)[:3]
