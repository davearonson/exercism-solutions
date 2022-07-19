defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) do
    # We don't ALWAYS need it sorted below so that's a bit of a waste,
    # but it's only five numbers, trivial time to sort.
    sorted = Enum.sort(dice)
    case category do
      # could use apply/3 IF we wanted to make these public
      :ones            -> ones(sorted)
      :twos            -> twos(sorted)
      :threes          -> threes(sorted)
      :fours           -> fours(sorted)
      :fives           -> fives(sorted)
      :sixes           -> sixes(sorted)
      :full_house      -> full_house(sorted)
      :four_of_a_kind  -> four_of_a_kind(sorted)
      :little_straight -> little_straight(sorted)
      :big_straight    -> big_straight(sorted)
      :choice          -> choice(sorted)
      :yacht           -> yacht(sorted)
    end
  end

  defp ones(dice),   do: score_set(dice, 1)
  defp twos(dice),   do: score_set(dice, 2)
  defp threes(dice), do: score_set(dice, 3)
  defp fours(dice),  do: score_set(dice, 4)
  defp fives(dice),  do: score_set(dice, 5)
  defp sixes(dice),  do: score_set(dice, 6)
  defp score_set(dice, n), do: Enum.count(dice, fn d -> d == n end) * n

  # yacht cannot be scored as full house
  defp full_house([a,a,a,b,b] = dice) when a != b, do: Enum.sum(dice)
  defp full_house([a,a,b,b,b] = dice) when a != b, do: Enum.sum(dice)
  defp full_house(_), do: 0

  # yacht CAN be scored as 4-of-kind!
  defp four_of_a_kind([a,a,a,a,_b]), do: a * 4
  defp four_of_a_kind([_a,b,b,b,b]), do: b * 4
  defp four_of_a_kind(_), do: 0

  defp little_straight([1,2,3,4,5]), do: 30
  defp little_straight(_), do: 0

  defp big_straight([2,3,4,5,6]), do: 30
  defp big_straight(_), do: 0

  defp choice(dice), do: Enum.sum(dice)

  defp yacht([d,d,d,d,d]), do: 50
  defp yacht(_), do: 0
end
