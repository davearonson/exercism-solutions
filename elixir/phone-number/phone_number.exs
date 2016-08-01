defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("123-456-7890")
  "1234567890"

  iex> Phone.number("+1 (303) 555-1212")
  "3035551212"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t) :: String.t
  def number(raw) do
    validate_length(do_number(String.graphemes(raw)))
  end

  @bad_number "0000000000"

  defp do_number([]), do: ""

  defp do_number([first|rest]), do: "#{digit_value(first)}#{do_number(rest)}"

  # too bad ranges are only for integers :-P
  defp digit_value(char) when char >= "0" and char <= "9", do: char
  defp digit_value(char) when char >= "a" and char <= "z", do: "0"
  defp digit_value(_), do: ""

  defp validate_length(str), do: do_validate_length(str, String.length(str))

  defp do_validate_length(str, 10), do: str

  defp do_validate_length(str, 11) do
    # String.first is not allowed in guards, and ["1"|rest] is not valid :-P
    case String.first(str) do
      "1" -> String.slice(str, 1, 10)
      _   -> @bad_number
    end
  end

  defp do_validate_length(_, _), do: @bad_number


  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("123-456-7890")
  "123"

  iex> Phone.area_code("+1 (303) 555-1212")
  "303"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    String.slice(number(raw), 0, 3)
  end


  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("123-456-7890")
  "(123) 456-7890"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    do_pretty(number(raw))
  end

  defp do_pretty(num) do
    "(#{String.slice(num, 0..2)}) #{String.slice(num, 3..5)}-#{String.slice(num, 6..9)}"
  end

end
