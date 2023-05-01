defmodule StringUtils do
  @doc ~S"""

    Return true if the string passed in parameter is an integer.
    Method based on `Integer.parse`

    ## Examples
      iex> StringUtils.stringIsInteger?("42")
      true

      iex> StringUtils.stringIsInteger?("")
      false

      iex> StringUtils.stringIsInteger?("42.42")
      false

      iex> StringUtils.stringIsInteger?("42xxx")
      false

      iex> StringUtils.stringIsInteger?("integer")
      false

  """
  @spec stringIsInteger?(String.t()) :: boolean
  def stringIsInteger?(str) do
    case Integer.parse(str) do
      {_, ""} -> true
      _ -> false
    end
  end

  @doc ~S"""

    Return true if the string passed in parameter is a float.
    Method based on `Float.parse`

    ## Examples
      iex> StringUtils.stringIsFloat?("42")
      true

      iex> StringUtils.stringIsFloat?("42.42")
      true

      iex> StringUtils.stringIsFloat?("")
      false

      iex> StringUtils.stringIsFloat?("42.42xxx")
      false

      iex> StringUtils.stringIsFloat?("float")
      false

  """
  @spec stringIsFloat?(String.t()) :: boolean
  def stringIsFloat?(str) do
    case Float.parse(str) do
      {_, ""} -> true
      _ -> false
    end
  end
end
