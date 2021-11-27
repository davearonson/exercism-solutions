defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    do_extract_from_path(data, String.split(path, "."))
  end

  # does NOT account for what might happen if data is
  # of a type that does not support Access!
  defp do_extract_from_path(data, [head|rest]) do
    datum = data[head]
    if is_nil(datum), do: nil, else: do_extract_from_path(datum, rest)
  end
  defp do_extract_from_path(data, []), do: data

  def get_in_path(data, path), do: get_in(data, String.split(path, "."))
end
