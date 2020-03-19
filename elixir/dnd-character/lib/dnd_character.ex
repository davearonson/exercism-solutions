defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    # can't just div(score - 10, 2), trunc((score - 10) / 2), nor round,
    # because negative halves round, and negative floats truncate,
    # *towards zero*, not strictly *down*.  subtracting anything greater than
    # zero but less than a half, makes the right answer the nearest integer.
    round((score - 10) / 2 - 0.1)
  end

  @spec ability :: pos_integer()
  def ability do
    rolls = do_rolls(4, 6, 0)
    Enum.sum(rolls) - Enum.min(rolls)
  end

  defp do_rolls(dice, _size, dice), do: []
  defp do_rolls(dice,  size, done)  do
    [Enum.random(1..size) | do_rolls(dice, size, done + 1) ]
  end

  @spec character :: t()
  def character do
    con = ability()
    %DndCharacter {
      strength:     ability(),
      dexterity:    ability(),
      constitution: con,
      intelligence: ability(),
      wisdom:       ability(),
      charisma:     ability(),
      hitpoints:    10 + modifier(con)
    }
  end
end
