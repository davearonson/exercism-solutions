defmodule LogParser do
  import String

  def valid_line?(line) do
    starts_with?(line, "[DEBUG]") or
    starts_with?(line, "[INFO]") or
    starts_with?(line, "[WARNING]") or
    starts_with?(line, "[ERROR]") 
  end

  def split_line(line) do
    split(line, ~r/<[=~*-]*>/U)  # U means Ungreedy
  end

  def remove_artifacts(line) do
    replace(line, ~r/end-of-line\d+/i, "")
  end

  def tag_with_user_name(line) do
    if (results = Regex.run(~r/User\s+([^\s]+)/, line)) do
      [_both, name] = results
      "[USER] #{name} #{line}"
    else
      line
    end
  end
end
