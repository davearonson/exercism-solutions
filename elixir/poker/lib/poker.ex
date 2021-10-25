defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """

  @hand_values %{
    straight_flush:   9,
    four_of_a_kind:   8,
    full_house:       7,
    flush:            6,
    straight:         5,
    three_of_a_kind:  4,
    two_pair:         3,
    one_pair:         2,
    high_card:        1
  }

  @rank_values %{
    "2"  =>   2,
    "3"  =>   3,
    "4"  =>   4,
    "5"  =>   5,
    "6"  =>   6,
    "7"  =>   7,
    "8"  =>   8,
    "9"  =>   9,
    "10" =>  10,
    "J"  =>  11,
    "Q"  =>  12,
    "K"  =>  13,
    "A"  =>  14
  }
  @num_ranks Enum.count(@rank_values)

  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand([first | rest]),
    do: do_best_hand(rest, hand_kind(first), [first])

  defp do_best_hand([first | rest], best_so_far, winners) do
    kind = hand_kind(first)

    case compare_hands(kind, best_so_far) do
      -1 -> do_best_hand(rest, best_so_far, winners)
       0 -> do_best_hand(rest, best_so_far, [first | winners])
       1 -> do_best_hand(rest, kind, [first])
    end
  end
  defp do_best_hand([], _, winners), do: Enum.reverse(winners)

  defp hand_kind(hand) do
    hand
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&cardify/1)
    |> Enum.sort_by(fn {r, _} -> r end)
    |> analyze_hand
  end

  defp cardify(["1", "0", suit]), do: {@rank_values["10"], suit}
  defp cardify([rank,     suit]), do: {@rank_values[rank], suit}

  # normal straight flush
  defp analyze_hand([{rank_1, suit},
                     {rank_2, suit},
                     {rank_3, suit},
                     {rank_4, suit},
                     {rank_5, suit}])
      when rank_2 == rank_1 + 1 and
           rank_3 == rank_2 + 1 and
           rank_4 == rank_3 + 1 and
           rank_5 == rank_4 + 1,
      do: {@hand_values[:straight_flush], {rank_5}}

  # ace low straight flush; ace does NOT count as HIGH card!
  defp analyze_hand([{rank_1, suit},
                     {rank_2, suit},
                     {rank_3, suit},
                     {rank_4, suit},
                     {rank_5, suit}])
      when rank_2 == rank_1 + 1 and
           rank_3 == rank_2 + 1 and
           rank_4 == rank_3 + 1 and
           rank_5 == rank_1 + @num_ranks - 1,
      do: {@hand_values[:straight_flush], {rank_4}}

  # four with other of *greater* rank
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_1, _},
                     {rank_1, _},
                     {rank_2, _}]),
      do: {@hand_values[:four_of_a_kind], {rank_1, rank_2}}

  # four with other of *lesser* rank
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_2, _}]),
      do: {@hand_values[:four_of_a_kind], {rank_2, rank_1}}

  # full house, three of *lower* rank than pair
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_1, _},
                     {rank_2, _},
                     {rank_2, _}]),
      do: {@hand_values[:full_house], {rank_1, rank_2}}

  # full house, three of *higher* rank than pair
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_2, _}]),
      do: {@hand_values[:full_house], {rank_2, rank_1}}

  # flush
  defp analyze_hand([{rank_1, suit},
                     {rank_2, suit},
                     {rank_3, suit},
                     {rank_4, suit},
                     {rank_5, suit}]),
      do: {@hand_values[:flush], {rank_5, rank_4, rank_3, rank_2, rank_1}}

  # normal straight
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_4, _},
                     {rank_5, _}])
      when rank_2 == rank_1 + 1 and
           rank_3 == rank_2 + 1 and
           rank_4 == rank_3 + 1 and
           rank_5 == rank_4 + 1
      do
    {@hand_values[:straight], {rank_5}}
  end

  # ace-low straight -- ace does not count as high
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_4, _},
                     {rank_5, _}])
      when rank_2 == rank_1 + 1 and
           rank_3 == rank_2 + 1 and
           rank_4 == rank_3 + 1 and
           rank_5 == rank_1 + @num_ranks - 1
      do
    {@hand_values[:straight], {rank_4}}
  end

  # three with others of *greater* rank
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_1, _},
                     {rank_2, _},
                     {rank_3, _}]),
      do: {@hand_values[:three_of_a_kind], {rank_1, rank_3, rank_2}}

  # three with others of *lesser* rank
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_3, _},
                     {rank_3, _}]),
      do: {@hand_values[:three_of_a_kind], {rank_3, rank_2, rank_1}}

  # three with others on both ends
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_3, _}]),
      do: {@hand_values[:three_of_a_kind], {rank_2, rank_3, rank_1}}

  # two pair with other of *greater* rank
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_3, _}]),
      do: {@hand_values[:two_pair], {rank_2, rank_1, rank_3}}

  # two pair with other of *lesser* rank
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_3, _}]),
      do: {@hand_values[:two_pair], {rank_3, rank_3, rank_1}}

  # two pair with other in middle
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_3, _}]),
      do: {@hand_values[:two_pair], {rank_3, rank_1, rank_2}}

  # one pair at bottom
  defp analyze_hand([{rank_1, _},
                     {rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_4, _}]),
      do: {@hand_values[:one_pair], {rank_1, rank_4, rank_3, rank_2}}

  # one pair with one lower card and two higher
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_4, _}]),
      do: {@hand_values[:one_pair], {rank_2, rank_4, rank_3, rank_1}}

  # one pair with one higher card and two lower
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_3, _},
                     {rank_4, _}]),
      do: {@hand_values[:one_pair], {rank_3, rank_4, rank_2, rank_1}}

  # one pair at top
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_4, _},
                     {rank_4, _}]),
      do: {@hand_values[:one_pair], {rank_4, rank_3, rank_2, rank_1}}

  # no better analysis, fall back to high card
  defp analyze_hand([{rank_1, _},
                     {rank_2, _},
                     {rank_3, _},
                     {rank_4, _},
                     {rank_5, _}]),
      do: {@hand_values[:high_card], {rank_5, rank_4, rank_3, rank_2, rank_1}}

  defp compare_hands({kind_1, details_1}, {kind_2, details_2}) do
    cond do
      kind_1    < kind_2    -> -1
      kind_1    > kind_2    ->  1
      details_1 < details_2 -> -1
      details_1 > details_2 ->  1
      true                  ->  0
    end
  end
end
