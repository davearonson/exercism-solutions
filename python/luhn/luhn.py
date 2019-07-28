class Luhn:
    def __init__(self, card_num):
        self.card_num = card_num  # we may need to retrieve original

    def valid(self):
        digits = self.card_num.replace(" ", "")
        if len(digits) <= 1: return False
        try: total = self.__class__.calc(digits)
        except ValueError: return False
        return total % 10 == 0

    @staticmethod
    def calc(digits):
        return Luhn._calc(digits, False, 0)

    @staticmethod
    def _calc(digits, even_spot, accumulator):
        if not digits: return accumulator
        value = int(digits[-1])
        if even_spot:
            value = value * 2
            if value >= 10: value = value - 9
        return Luhn._calc(digits[:-1], not even_spot, accumulator + value)
