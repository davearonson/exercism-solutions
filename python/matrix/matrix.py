class Matrix:

    def __init__(self, matrix_string):
        # use splitlines() instead of split("\n") because
        # "".splitlines() is [] but "".split("\n") is [""],
        # which is not totally empty.
        rows = matrix_string.splitlines()
        self.rows = [list(map(int, row.split())) for row in rows]

    def row(self, index):
        if not self.rows: return None
        if index < 1: return None
        if index > len(self.rows): return None
        return self.rows[index-1]

    def column(self, index):
        if not self.rows: return None
        if index < 1: return None
        if index > len(self.rows[0]): return None
        return [row[index-1] for row in self.rows]
