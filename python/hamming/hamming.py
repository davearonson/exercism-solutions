# constants so we can use them outside, such as in tests
InvalidBaseMessage    = "Invalid base detected"
LengthMismatchMessage = "DNA strands must have the same length"
NotStringMessage      = "DNA strands must be strings"
ValidBases            = "ACGT"


def distance(strand_a, strand_b):

    if not (isinstance(strand_a, str) and isinstance(strand_b, str)):
        raise ValueError(NotStringMessage)

    if len(strand_a) != len(strand_b): raise ValueError(LengthMismatchMessage)

    for base in strand_a + strand_b:
        if not base in ValidBases: raise(ValueError(InvalidBaseMessage))

    # could make this a oneliner, like:
    # return len([1 for pair in zip(strand_a, strand_b) if pair[0] != pair[1]])
    # but IMHO the clarity is worth the extra lines.
    # also, could use any value; just chose 1 as a placeholder likely to be
    # smaller than storing the actual mismatched pair, and in case i wanted
    # to sum it instead of looking at the length.
    pairs = zip(strand_a, strand_b)
    mismatches = [1 for a,b in pairs if a != b]
    return len(mismatches)
