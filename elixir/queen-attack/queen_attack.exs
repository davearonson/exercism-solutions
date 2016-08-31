# Thanks to exercism.io / github.com user veelenga for
# telling me about map_join and reminding me of "pinned" matching.

defmodule Queens do
  @type t :: %Queens{ black: {integer, integer}, white: {integer, integer} }
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(white \\ {0, 3}, black \\ {7, 3})
  def new(white, white), do: raise ArgumentError
  def new(white, black), do: %Queens{ black: black, white: white }

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    (0..7) |> Enum.map_join("\n", &(row(&1, queens)))
  end

  def row(row, queens) do
    (0..7) |> Enum.map_join(" ", &(cell(row, &1, queens)))
  end

  def cell(row, col, %{black: black_loc, white: white_loc}) do
    case {row, col} do
      ^black_loc -> "B"
      ^white_loc -> "W"
      _          -> "_"
    end
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    match(queens.white, queens.black)
  end

  def match({row , _   }, {row , _   }), do: true
  def match({_   , col }, {_   , col }), do: true
  def match({row1, col1}, {row2, col2}) do
    row1 - col1 == row2 - col2 ||
    (7 - row1) - col1 == (7 - row2) - col2
  end
end
