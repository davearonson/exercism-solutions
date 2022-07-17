defmodule Animal do
  defstruct [:name, :line2, :action]
end

defmodule FoodChain do
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @wriggle "wriggled and jiggled and tickled inside her"
  @animals {
    %Animal{name: :fly,    line2: nil},  # footer serves purpose of line2 here
    %Animal{name: :spider, line2: "It #{@wriggle}.", action: " that #{@wriggle}"},
    %Animal{name: :bird,   line2: "How absurd to swallow a bird!"},
    %Animal{name: :cat,    line2: "Imagine that, to swallow a cat!"},
    %Animal{name: :dog,    line2: "What a hog, to swallow a dog!"},
    %Animal{name: :goat,   line2: "Just opened her throat and swallowed a goat!"},
    %Animal{name: :cow,    line2: "I don't know how she swallowed a cow!"},
    %Animal{name: :horse,  line2: "She's dead, of course!"}
  }
  @max_index tuple_size(@animals) - 1
  @footer "I don't know why she swallowed the fly. Perhaps she'll die."

  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop), do: do_recite(start - 1, stop - 1, [])

  defp do_recite(start, stop, acc) when stop >= start do
    # do in reverse so we don't have to reverse when done
    do_recite(start, stop - 1, [make_verse(stop) | acc])
  end
  defp do_recite(_, _, acc), do: Enum.join(acc, "\n")

  defp make_verse(n) do
    animal = elem(@animals, n)
    # good thing none start with a vowel!  :-)
    header = "I know an old lady who swallowed a #{animal.name}."
    [header, animal.line2, make_rest(n)]
      |> Enum.reject(&is_nil/1)  # need this for fly :-(
      |> Enum.join("\n")
  end

  defp make_rest(0),          do: "#{@footer}\n"
  defp make_rest(@max_index), do: ""  # joining w/ \n above will give us one
  defp make_rest(n),          do: "#{make_swallows(n, [])}\n#{@footer}\n"

  defp make_swallows(0, acc), do: acc |> Enum.reverse |> Enum.join("\n")
  defp make_swallows(n, acc) do
    eater = elem(@animals, n)
    prey = elem(@animals, n - 1)
    line = "She swallowed the #{eater.name} to catch the #{prey.name}#{prey.action}."
    make_swallows(n - 1, [line | acc])
  end
end
