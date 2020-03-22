defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  defstruct [
    :first_roll,  # is this the first roll of this frame?
    :frame,       # frame number of course
    :mult_1,      # # to multiply next ball by, in case of strike or spare
    :mult_2,      # # to multiply ball after next by, in case of strike
    :rolls,       # rolls -- added in reverse, for easy access to last couple
    :score        # score so far
  ]

  @spec start() :: any
  def start do
    %__MODULE__{
      first_roll: true,
      frame:      1,
      mult_1:     1,
      mult_2:     1,
      rolls:      [],
      score:      0
    }
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()

  @game_over_error     {:error, "Cannot roll after game is over"}
  @too_many_pins_error {:error, "Pin count exceeds pins on the lane"}

  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}
  def roll(_, roll) when roll > 10, do: @too_many_pins_error

  def roll(%{first_roll: false, rolls: [last|_rest]}, roll)
      when last + roll > 10 do
    @too_many_pins_error
  end

  # after final strike, strike in 11th frame, and 12th -- NOT TESTED!
  def roll(%{frame: 13, rolls: [10|[10|_rest]]}, _), do: @game_over_error

  # after final strike, and non-strike (and whatever, even spare) in 11th frame
  def roll(%{frame: 12, rolls: [_last|[second|_rest]]}, _) when second != 10 do
    @game_over_error
  end

  # after final spare, and its bonus roll
  def roll(%{first_roll: false, frame: 11, rolls: [_|[spare1|[spare2]]]}, _)
      when spare1 + spare2 == 10 do
    @game_over_error
  end

  # after normal final frame
  def roll(%{frame: 11, rolls: [last|[second|_rest]]}, _)
      when last < 10 and last + second < 10 do
    @game_over_error
  end

  # strike
  def roll(game = %{first_roll: true, frame: frame}, 10) when frame < 10 do
    new_game(game, true, game.mult_2 + 1, 2, 10)
  end

  # spare
  def roll(game = %{first_roll: false, frame: frame, rolls: [last|_]}, roll)
      when roll + last == 10 and frame < 10 do
    new_game(game, true, game.mult_2 + 1, 1, roll)
  end

  # anything else
  def roll(game, roll) do
    new_first = (not game.first_roll) or roll == 10
    new_game(game, new_first, game.mult_2, 1, roll)
  end

  defp new_game(game, first_roll, mult_1, mult_2, roll) do
    %__MODULE__{game |
      first_roll: first_roll,
      frame:      game.frame + (if first_roll, do: 1, else: 0),
      mult_1:     mult_1,
      mult_2:     mult_2,
      rolls:      [roll|game.rolls],
      score:      game.score + roll * game.mult_1
    }
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @must_end_error {:error, "Score cannot be taken until the end of the game"}

  @spec score(any) :: integer | String.t()
  def score(%{frame: frame}) when frame <= 10, do: @must_end_error

  # awaiting bonus ball for a final spare
  # can't incorporate this into above cuz unstarted won't have last & second
  def score(%{first_roll: true, frame: 11, rolls: [last|[next|_rest]]})
      when last + next == 10 do
    @must_end_error
  end

  # awaiting first bonus ball for a final strike
  def score(%{frame: 11, rolls: [10|_rest]}), do: @must_end_error

  # awaiting second bonus ball for a final strike after 1st was also strike
  def score(%{frame: 12, rolls: [10|[10|_rest]]}), do: @must_end_error

  # awaiting second bonus ball for a final strike after 1st was normal
  def score(%{frame: 11, rolls: [_last|[10|_rest]]}) do
    @must_end_error
  end

  def score(game), do: game.score

end
