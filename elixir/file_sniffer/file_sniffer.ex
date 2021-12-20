defmodule FileSniffer do
  # COULD have done TWO maps, ext to mime and bytes to mime, but that
  # kinda rubbed me the wrong way.  Maybe if there were so many types
  # that the speedup is worth it... but not for a tiny exercise like this.
  @exe_bytes <<0x7F, 0x45, 0x4C, 0x46>>
  @bmp_bytes <<0x42, 0x4D>>
  @png_bytes <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>
  @jpg_bytes <<0xFF, 0xD8, 0xFF>>
  @gif_bytes <<0x47, 0x49, 0x46>>
  @types %{
    "exe" => %{mime_type: "application/octet-stream", bytes: @exe_bytes},
    "bmp" => %{mime_type: "image/bmp", bytes: @bmp_bytes},
    "png" => %{mime_type: "image/png", bytes: @png_bytes},
    "jpg" => %{mime_type: "image/jpg", bytes: @jpg_bytes},
    "gif" => %{mime_type: "image/gif", bytes: @gif_bytes}
  }

  def type_from_extension(extension) do
    @types[extension][:mime_type]
  end

  def type_from_binary(file_binary) do
    entry =
      @types
      |> Map.values
      |> Enum.find(fn(e) -> starts_with(file_binary, e[:bytes]) end)
    entry[:mime_type]  # if entry is nil this gives nil, fine
  end

  # WTF, Exercism is STILL gritching that I need to compare the first few bytes
  # of the arg of type_from_binary with the signature, but that's exactly what
  # this code DOES!  Guess it's just too stupid to understand that it's doing
  # so even though the code doing so is not CONTAINED WITHIN type_from_binary!  :-P
  # ADDED: Okay, let's see if wrapping the signature in <<>> will make it STFU.
  defp starts_with(<<@exe_bytes, _::binary>>, <<@exe_bytes>>), do: true
  defp starts_with(<<@bmp_bytes, _::binary>>, <<@bmp_bytes>>), do: true
  defp starts_with(<<@png_bytes, _::binary>>, <<@png_bytes>>), do: true
  defp starts_with(<<@jpg_bytes, _::binary>>, <<@jpg_bytes>>), do: true
  defp starts_with(<<@gif_bytes, _::binary>>, <<@gif_bytes>>), do: true
  defp starts_with(_, _), do: false

  # COULD do this instead, but Exercism gritches that
  # we're not comparing with the <<>> special form,
  # though IMHO we darn well ARE, in the == line!  :-P
  # defp starts_with(file, signature) do
    # do NOT use String.length to figure the length;
    # it ass-u-me's UTF8 encoding, and this is binary!
    # then, can't put that expression into binary-size();
    # that requires an int or var, not an expression. :-P
    # len = byte_size(signature)
    # signature == <<file::binary-size(len)>>
  # end

  def verify(file_binary, extension) do
    from_ext = type_from_extension(extension)
    if from_ext == type_from_binary(file_binary) do
      {:ok, from_ext}
    else
      {:error, "Warning, file format and file extension do not match."}
    end
  end
end
