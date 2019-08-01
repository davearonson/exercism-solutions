class Clock(object):
    def __init__(self, hour, minute):
        total = hour * 60 + minute
        self._hour = (total // 60) % 24
        self._minute = total % 60

    def __repr__(self):
        return f"{'%02d' % self._hour}:{'%02d' % self._minute}"

    def __eq__(self, other):
        return self._hour == other._hour and self._minute == other._minute

    def __add__(self, minutes):
        return self.__class__(self._hour, self._minute + minutes)

    def __sub__(self, minutes):
        return self.__class__(self._hour, self._minute - minutes)
