defmodule RobotSimulator do
  @type t :: %RobotSimulator{ direction: atom, position: {integer, integer} }
  defstruct direction: :north, position: {0,0}
  @directions [:north, :east, :south, :west]
  @directions_to_numbers %{north: 0, east: 1, south: 2, west: 3}
  @numbers_to_directions %{0 => :north, 1 => :east, 2 => :south, 3 => :west}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: { integer, integer }) :: RobotSimulator.t()

  def create(direction \\ :north, position \\ {0,0}) do
    cond do
      ! Enum.member?(@directions, direction) ->
        { :error, "invalid direction" }
      ! (is_tuple(position) &&
         tuple_size(position) == 2 &&
         is_integer(elem(position, 0)) &&
         is_integer(elem(position, 1))) ->
        { :error, "invalid position" } 
      true ->
        %RobotSimulator{direction: direction, position: position}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t ) :: any
  def simulate(robot, instructions) do
    do_simulate(robot, instructions |> String.graphemes)
  end

  defp do_simulate(robot, [instruction|more]) do
    case instruction do
      "A" -> do_simulate(advance(robot) , more)
      "L" -> do_simulate(turn(robot, -1), more)
      "R" -> do_simulate(turn(robot,  1), more)
      _   -> { :error, "invalid instruction" }
    end
  end
  defp do_simulate(robot, []), do: robot

  defp advance(robot) do
    # TODO MAYBE: we could probably do some funny math
    # on the direction index, to replace case....
    case robot.direction do
      :north -> move(robot, 1,  1)
      :east  -> move(robot, 0,  1)
      :south -> move(robot, 1, -1)
      :west  -> move(robot, 0, -1)
    end
  end

  defp move(robot, axis, amount) do
    create(robot.direction,
           put_elem(robot.position,
                    axis,
                    elem(robot.position, axis) + amount))
  end

  defp turn(robot, way) do
    # add 4 just in case it's a left turn from north
    new_dir_num = rem(@directions_to_numbers[robot.direction] + way + 4, 4)
    create(@numbers_to_directions[new_dir_num], robot.position)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position, as a tuple of x,y coordinates.
  """
  @spec position(robot :: any) :: { integer, integer }
  def position(robot), do: robot.position
end
