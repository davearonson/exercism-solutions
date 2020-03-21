if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("flatten_array.exs")
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule ChangeTest do
  use ExUnit.Case

  test "returns original list if there is nothing to flatten" do
    assert Flattener.flatten([1, 2, 3]) ==  [1, 2, 3]
  end

  test "flattens an empty nested list" do
    assert Flattener.flatten([[]]) ==  []
  end

  test "flattens a nested list" do
    assert Flattener.flatten([1,[2,[3],4],5,[6,[7,8]]]) == [1, 2, 3, 4, 5, 6, 7, 8]
  end

  test "removes nil from list" do
    assert Flattener.flatten([1, nil, 2]) ==  [1, 2]
  end

  test "removes nil from a nested list" do
    assert Flattener.flatten([1, [2, nil, 4], 5]) ==  [1, 2, 4, 5]
  end

  test "returns an empty list if all values in nested list are nil" do
    assert Flattener.flatten([nil, [nil], [nil, [nil]]]) ==  []
  end
end
