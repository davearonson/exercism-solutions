# constants so we can use them outside, such as in tests
# pylint: disable=C0326
INVALID_BASE_MESSAGE    = "Invalid base detected"
LENGTH_MISMATCH_MESSAGE = "DNA strands must have the same length"
NOT_STRING_MESSAGE      = "DNA strands must be strings"
VALID_BASES             = "ACGT"


def distance(strand_a, strand_b):

    if not (isinstance(strand_a, str) and isinstance(strand_b, str)):
        raise ValueError(NOT_STRING_MESSAGE)

    if len(strand_a) != len(strand_b): raise ValueError(LENGTH_MISMATCH_MESSAGE)

    for base in strand_a + strand_b:
        if not base in VALID_BASES: raise ValueError(INVALID_BASE_MESSAGE)

    # could make this a oneliner, like:
    # return len([1 for pair in zip(strand_a, strand_b) if pair[0] != pair[1]])
    # but IMHO the clarity is worth the extra lines.
    # also, could use any value; just chose 1 as a placeholder likely to be
    # smaller than storing the actual mismatched pair, and in case i wanted
    # to sum it instead of looking at the length.
    pairs = zip(strand_a, strand_b)
    mismatches = [1 for a,b in pairs if a != b]
    return len(mismatches)
