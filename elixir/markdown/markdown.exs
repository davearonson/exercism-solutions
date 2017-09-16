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
  def parse(m) do
    m |> String.split("\n") |> Enum.map(&process/1) |> Enum.join |> patch
  end

  defp process(t) do
    case t |> String.first do
      "#" -> t |> parse_header_md_level |> enclose_with_header_tag
      "*" -> t |> parse_list_md_level
      _   -> t |> String.split |> enclose_with_paragraph_tag
    end
  end

  defp parse_header_md_level(hwt) do
    [h | t] = String.split(hwt)
    {h |> String.length |> to_string, Enum.join(t, " ")}
  end

  defp parse_list_md_level(l) do
    t = l |> String.trim_leading("* ") |> String.split
    "<li>#{join_words_with_tags(t)}</li>"
  end

  defp enclose_with_header_tag({hl, htl}) do
    "<h#{hl}>#{htl}</h#{hl}>"
  end

  defp enclose_with_paragraph_tag(t) do
    "<p>#{join_words_with_tags(t)}</p>"
  end

  defp join_words_with_tags(t) do
    t |> Enum.map(&replace_md_with_tag/1) |> Enum.join(" ")
  end

  defp replace_md_with_tag(w) do
    w |> replace_prefix_md |> replace_suffix_md
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ ->
        String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ ->
        String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end

  defp patch(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
