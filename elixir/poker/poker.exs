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

  @kinds [
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush,
    :straight,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    do_best_hand(hands, {:high_card, "2"}, [])
  end

  defp do_best_hand([first|rest], win = {win_kind, _}, winners) do
    kind = hand_kind(first)
    case compare_hands(first, win) do
      -1 -> do_best_hand(rest, win, winners)
       1 -> do_best_hand(rest, {kind, hand_details(first, kind)}, [first])
       0 -> do_best_hand(rest, win, [first|winners]}
    end
  end
  defp do_best_hand([], _, winners), do: winners |> Enum.reverse

  defp compare_hands(first, {win_kind, win_details}) do
  end

  # THIS IS WRONG, but makes tests so far pass
  defp hand_kind(hand) do
    hand |> List.last |> String.graphemes |> List.first
  end

  defp break_tie(challenger, rest, win = {win_kind, win_details}, winners) do
    details = hand_details(challenger, win_kind)
    cond do
      details < win_details -> do_best_hand(rest, win, winners)
      details > win_details -> do_best_hand(rest, win, [challenger])
      true                  -> do_best_hand(rest, win, [challenger|winners])
    end
  end

  # THIS IS WRONG, but makes tests so far pass
  defp hand_details(hand, _kind) do
    hand |> List.first |> String.graphemes |> List.first
  end

end
