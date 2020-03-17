class Matrix(object):

    def __init__(self, matrix_string):
        # use splitlines() instead of split("\n") because
        # "".splitlines() is [] but "".split("\n") is [""],
        # which is not totally empty.
        rows = matrix_string.splitlines()
        self.rows = [list(map(int, row.split())) for row in rows]

    def row(self, index):
        if self.rows and 0 < index <= len(self.rows): return self.rows[index-1]
        else: return None

    def column(self, index):
        if self.rows and 0 < index <= len(self.rows[0]):
            return [row[index-1] for row in self.rows]
        else: return None
