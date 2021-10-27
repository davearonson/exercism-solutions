defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({n1,d1}, {n2,d2}), do: reduce({n1 * d2 + n2 * d1, d1 * d2})

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({n1,d1}, {n2,d2}), do: reduce({n1 * d2 - n2 * d1, d1 * d2})

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({n1,d1}, {n2,d2}), do: reduce({n1 * n2, d1 * d2})

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({n1,d1}, {n2,d2}), do: reduce({n1 * d2, n2 * d1})

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({n,d}), do: reduce({Kernel.abs(n), Kernel.abs(d)})

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, exp :: integer) :: rational
  def pow_rational({n,d}, exp) when exp >= 0 do
    # trunc is needed here because math.pow returns a float, even if
    # both arguments are integers, so Integer.gcd barfs inside reduce
    reduce({trunc(:math.pow(n, exp)), trunc(:math.pow(d, exp))})
  end
  def pow_rational({n,d}, exp) do
    reduce({trunc(:math.pow(d, -exp)), trunc(:math.pow(n, -exp))})
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, r :: rational) :: float
  def pow_real(x, {n,d}), do: :math.pow(x, n/d)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({n,d}) when d < 0, do: reduce({-n,-d})
  def reduce({n,d}) do
    gcd = Integer.gcd(n,d)
    {div(n, gcd), div(d, gcd)}
  end
end
