defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]), do: true
  def chain?([{x, x}]), do: true
  def chain?([{x, y}]) when x != y, do: false
  def chain?([head | tail]) do 
    # take these in reverse order of usual search in the rest, because
    # this is what is *establishing* the parameters, not *fitting* them
    {must_end, must_match} = head
    # must start with the "any-izer" else it will glom onto first match,
    # which may be wrong
    any_chains?(tail, must_match, must_end)
  end

  defp any_chains?(pool, must_match, must_end),
    do: Enum.any?(pool, &chain_helper(&1, pool, must_match, must_end))

  # extracted so as not to make a huge ugly "fn" expression inline above
  defp chain_helper(candidate, tail, must_match, must_end) do
    rest = remove_from(tail, candidate, [])
    pool = [candidate | rest]
    do_chain(pool, must_match, must_end, [])
  end

  # if we're down to one, with no rejects, and it matches precisely, either
  # forward or backward, yes we can chain.  i'm doing it this way rather than
  # keying off an empty pool, because it's easier to check, rather than keeping
  # track of the latest status.  i suspect there's some reasonably simple way
  # to do that but it's just not coming to me.
  defp do_chain([{must_match, must_end}], must_match, must_end, []), do: true
  defp do_chain([{must_end, must_match}], must_match, must_end, []), do: true

  # else if we're down to one, and no rejects, it's wrong, so no we can't
  defp do_chain([_], _must_match, _must_end, []), do: false

  # else if the first one matches our needs, look for ways to make
  # further progress, including with ones previously rejected
  defp do_chain([{must_match, other} | tail], must_match, must_end, rejects) do
    any_chains?(tail ++ rejects, other, must_end)
  end

  # else if it matches backwards, defer to forward case
  defp do_chain([{other, must_match} | tail], must_match, must_end, rejects) do
    do_chain([{must_match, other} | tail], must_match, must_end, rejects)
  end

  # else no match, and more than one, add it to rejects
  defp do_chain([head | tail], must_match, must_end, rejects) do
    do_chain(tail, must_match, must_end, [head | rejects])
  end

  defp do_chain([], _must_match, _must_end, _rejects), do: false

  defp remove_from([target | tail], target, acc), do: acc ++ tail
  defp remove_from([]             , _     , acc), do: acc
  defp remove_from([other  | tail], target, acc),
    do: remove_from(tail, target, [other | acc])

end
