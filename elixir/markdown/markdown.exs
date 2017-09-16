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
    |> Enum.join
    |> patch
  end

  defp process(line) do
    case line |> String.first do
      "#" -> line |> parse_header_md_level |> enclose_with_header_tag
      "*" -> line |> parse_list_md_level
      _   -> line |> String.split |> enclose_with_paragraph_tag
    end
  end

  defp parse_header_md_level(header_line) do
    [h | t] = String.split(header_line)
    {h |> String.length |> to_string, Enum.join(t, " ")}
  end

  defp parse_list_md_level(list_line) do
    t = list_line |> String.trim_leading("* ") |> String.split
    "<li>#{join_words_with_tags(t)}</li>"
  end

  defp enclose_with_header_tag({header_level, contents}) do
    "<h#{header_level}>#{contents}</h#{header_level}>"
  end

  defp enclose_with_paragraph_tag(line) do
    "<p>#{join_words_with_tags(line)}</p>"
  end

  defp join_words_with_tags(line) do
    line |> Enum.map(&replace_md_with_tag/1) |> Enum.join(" ")
  end

  defp replace_md_with_tag(word) do
    word |> replace_prefix_md |> replace_suffix_md
  end

  defp replace_prefix_md(word) do
    cond do
      word =~ ~r/^#{"__"}{1}/ ->
        String.replace(word, ~r/^#{"__"}{1}/, "<strong>", global: false)
      word =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ ->
        String.replace(word, ~r/_/, "<em>", global: false)
      true -> word
    end
  end

  defp replace_suffix_md(word) do
    cond do
      word =~ ~r/#{"__"}{1}$/ ->
        String.replace(word, ~r/#{"__"}{1}$/, "</strong>")
      word =~ ~r/[^#{"_"}{1}]/ ->
        String.replace(word, ~r/_/, "</em>")
      true -> word
    end
  end

  defp patch(text) do
    text
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
