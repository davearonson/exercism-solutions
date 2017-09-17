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
    |> Enum.map(&process_line/1)
    |> Enum.join  # note we do NOT preserve linebreaks!
    |> wrap_list_entries
  end

  defp process_line(line) do
    case String.first(line) do
      "#" -> process_header(line)
      "*" -> process_list_entry(line)
      _   -> process_text_line(line)
    end
  end

  defp process_header(line) do
    [hashes | _rest] = String.split(line)
    line
    |> String.replace(~r/^#{hashes}\s*/, "")
    |> wrap("h#{String.length(hashes)}")
  end

  defp process_list_entry(line) do
    line
    |> String.trim_leading("* ")
    |> String.split
    |> process_markdown_in_line
    |> wrap("li")
  end

  defp process_text_line(line) do
    line
    |> String.split
    |> process_markdown_in_line
    |> wrap("p")
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
    word
    |> replace_prefix_md
    |> replace_suffix_md
  end

  defp replace_prefix_md(word) do
    word
    |> String.replace_prefix("__", "<strong>")
    |> String.replace_prefix("_", "<em>")
  end

  defp replace_suffix_md(word) do
    word
    |> String.replace_suffix("__", "</strong>")
    |> String.replace_suffix("_", "</em>")
  end

  defp wrap_list_entries(text) do
    text
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end

end
