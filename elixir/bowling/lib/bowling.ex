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

  @game_over_error      {:error, "Cannot roll after game is over"}
  @frame_max            10  # NORMAL frames; bonuses could get "frame" up to 12
  @pins_max             10
  @too_many_pins_error  {:error, "Pin count exceeds pins on the lane"}

  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}
  def roll(_, roll) when roll > @pins_max, do: @too_many_pins_error

  def roll(%{first_roll: false, rolls: [last | _rest]}, roll)
      when last + roll > @pins_max,
      do: @too_many_pins_error

  # after final strike, strike in 11th frame, and 12th --
  # NOT TESTED by Exercism's supplied test suite
  def roll(%{frame: 13, rolls: [@pins_max | [@pins_max | _rest]]}, _),
    do: @game_over_error

  # after final strike, and non-strike (and whatever, even spare) in 11th frame
  def roll(%{frame: 12, rolls: [_last | [second | _rest]]}, _)
      when second != @pins_max,
      do: @game_over_error

  # after final spare, and its bonus roll
  def roll(%{first_roll: false, frame: 11, rolls: [_ | [spare1 | [spare2]]]}, _)
      when spare1 + spare2 == @pins_max,
      do: @game_over_error

  # after normal final frame
  def roll(%{frame: 11, rolls: [last | [second | _rest]]}, _)
      when last < @pins_max and last + second < @pins_max,
      do: @game_over_error

  # strike
  def roll(game = %{first_roll: true, frame: frame}, @pins_max)
      when frame < @frame_max,
      do: record_roll(game, true, game.mult_2 + 1, 2, @pins_max)

  # spare
  def roll(game = %{first_roll: false, frame: frame, rolls: [last | _]}, roll)
      when roll + last == @pins_max and frame < @frame_max,
      do: record_roll(game, true, game.mult_2 + 1, 1, roll)

  # anything else
  def roll(game, roll) do
    new_first = roll == @pins_max or not game.first_roll
    record_roll(game, new_first, game.mult_2, 1, roll)
  end

  defp record_roll(game, first_roll, mult_1, mult_2, roll) do
    %__MODULE__{
      game
      | first_roll: first_roll,
        frame:      game.frame + (if first_roll, do: 1, else: 0),
        mult_1:     mult_1,
        mult_2:     mult_2,
        rolls:      [roll | game.rolls],
        score:      game.score + roll * game.mult_1
    }
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @must_end_error {:error, "Score cannot be taken until the end of the game"}

  @spec score(any) :: integer | String.t()
  def score(%{frame: frame}) when frame <= @frame_max,
    do: @must_end_error

  # awaiting bonus ball for a final spare
  # can't incorporate this into above cuz unstarted won't have last & second
  def score(%{first_roll: true, frame: 11, rolls: [last | [next | _rest]]})
      when last + next == @pins_max,
      do: @must_end_error

  # awaiting first bonus ball for a final strike
  def score(%{frame: 11, rolls: [@pins_max | _rest]}),
    do: @must_end_error

  # awaiting second bonus ball for a final strike after 1st was also strike
  def score(%{frame: 12, rolls: [@pins_max | [@pins_max | _rest]]}),
    do: @must_end_error

  # awaiting second bonus ball for a final strike after 1st was normal
  def score(%{frame: 11, rolls: [_last | [@pins_max | _rest]]}),
    do: @must_end_error

  def score(game), do: game.score
end
