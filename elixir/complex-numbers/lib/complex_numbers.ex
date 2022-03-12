defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({r, _i}), do: r

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_r, i}), do: i

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul({r1, i1}, {r2, i2}), do: {r1 * r2 - i1 * i2, i1 * r2 + r1 * i2}
  def mul(c={_r1, _i1}, r), do: mul(c, {r, 0})
  def mul(r, c={_r1, _i1}), do: mul({r, 0}, c)

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add({r1, i1}, {r2, i2}), do: {r1 + r2, i1 + i2}
  def add(c={_r1, _i1}, r), do: add(c, {r, 0})
  def add(r, c={_r1, _i1}), do: add({r, 0}, c)

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub({r1, i1}, {r2, i2}), do: {r1 - r2, i1 - i2}
  def sub(c={_r1, _i1}, r), do: sub(c, {r, 0})
  def sub(r, c={_r1, _i1}), do: sub({r, 0}, c)

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div({r1, i1}, {r2, i2}) do
    squares2 = r2 ** 2 + i2 ** 2
    {(r1 * r2 + i1 * i2) / squares2, (i1 * r2 - r1 * i2) / squares2}
  end
  def div(c={_r1, _i1}, r), do: __MODULE__.div(c, {r, 0})
  def div(r, c={_r1, _i1}), do: __MODULE__.div({r, 0}, c)

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({r, i}), do: (r ** 2 + i ** 2) ** 0.5

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({r, i}), do: {r, -i}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({r, i}) do
    e_to_r = :math.exp(1) ** r
    {e_to_r * :math.cos(i), e_to_r * :math.sin(i)}
  end
end
