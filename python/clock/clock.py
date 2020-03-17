class Clock(object):
    def __init__(self, hour, minute):
        self._minutes = (hour * 60 + minute) % 1440  # 24 * 60

    def __repr__(self):
        hrs, mins = divmod(self._minutes, 60)
        return "%02d:%02d" % (hrs % 24, mins)

    def __eq__(self, other):
        return self._minutes == other._minutes

    def __add__(self, minutes):
        return self.__class__(0, self._minutes + minutes)

    def __sub__(self, minutes):
        return self.__class__(0, self._minutes - minutes)
