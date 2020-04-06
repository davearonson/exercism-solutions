defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    flag_set = make_flag_set(flags, files)
    [pattern, options] = apply_regex_options(pattern, flag_set)

    with {:ok, regex} <- Regex.compile(pattern, options) do
      grep_files(regex, flag_set, files)
    else
      err -> err
    end
  end

  defp make_flag_set(flags, files) do
    flag_set = Enum.reduce(flags, MapSet.new(), &MapSet.put(&2, &1))

    if Enum.count(files) > 1 do
      # others start w/ -, so no conflict
      MapSet.put(flag_set, "multifile")
    else
      flag_set
    end
  end

  defp apply_regex_options(pattern, flags) do
    opts = if MapSet.member?(flags, "-i"), do: "i", else: ""
    # in elixir regex -x means something different
    pattern = if MapSet.member?(flags, "-x"), do: "^#{pattern}$", else: pattern
    [pattern, opts]
  end

  defp grep_files(regex, flag_set, files) do
    files
    |> Enum.map(&grep_file(regex, flag_set, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
    |> ensure_ending_newline
  end

  defp grep_file(regex, flags, filename) do
    with {:ok, content} <- File.read(filename) do
      lines = matching_lines_in(content, regex, flags)

      cond do
        Enum.empty?(lines) ->
          nil

        MapSet.member?(flags, "-l") ->
          # we did more work than needed to get here, oh well
          filename

        true ->
          format_lines(lines, flags, filename)
      end
    else
      err -> err
    end
  end

  defp matching_lines_in(content, regex, flags) do
    content
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.filter(&grep_line(regex, flags, &1))
  end

  defp format_lines(lines, flags, filename) do
    lines
    |> Enum.map(&apply_line_flags(flags, &1, filename))
    |> Enum.join("\n")
  end

  defp apply_line_flags(flags, {line, number}, filename) do
    n = if MapSet.member?(flags, "-n"), do: "#{number + 1}:", else: ""
    f = if MapSet.member?(flags, "multifile"), do: "#{filename}:", else: ""
    "#{f}#{n}#{line}"
  end

  defp grep_line(regex, flags, {line, _number}) do
    String.match?(line, regex) == not MapSet.member?(flags, "-v")
  end

  defp ensure_ending_newline(""), do: ""

  defp ensure_ending_newline(str),
    do: if(String.slice(str, -1..-1) == "\n", do: str, else: "#{str}\n")
end
