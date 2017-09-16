defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t) :: String.t
  def parse(text) do
    text
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join  # note we do NOT preserve linebreaks!
    |> wrap_list_entries
  end

  defp process(line) do
    case line |> String.first do
      "#" -> process_header(line)
      "*" -> process_list_entry(line)
      _   -> process_text_line(line)
    end
  end

  defp process_header(line) do
    {header_level, contents} = parse_header_level(line)
    tag_type = "h#{header_level |> to_string}"
    wrap(contents, tag_type)
  end

  defp parse_header_level(line) do
    [h | t] = String.split(line)
    {h |> String.length, Enum.join(t, " ")}
  end

  defp process_list_entry(line) do
    content = line
              |> String.trim_leading("* ")
              |> String.split
              |> process_markdown_in_line
    wrap(content, "li")
  end

  defp process_text_line(line) do
    content = line |> String.split |> process_markdown_in_line
    wrap(content, "p")
  end

  defp wrap(content, tag_type) do
    "<#{tag_type}>#{content}</#{tag_type}>"
  end

  defp process_markdown_in_line(words) do
    words
    |> Enum.map(&replace_markdown_around_word/1)
    |> Enum.join(" ")
  end

  defp replace_markdown_around_word(word) do
    word |> replace_prefix_md |> replace_suffix_md
  end

  defp replace_prefix_md(word) do
    cond do
      word =~ ~r/^__/ ->
        word |> String.replace_prefix("__", "<strong>")
      word =~ ~r/^_/ ->
        word |> String.replace_prefix("_", "<em>")
      true -> word
    end
  end

  defp replace_suffix_md(word) do
    cond do
      word =~ ~r/__$/ ->
        word |> String.replace_suffix("__", "</strong>")
      word =~ ~r/[_$]/ ->
        word |> String.replace_suffix("_", "</em>")
      true -> word
    end
  end

  defp wrap_list_entries(text) do
    text
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end

end
