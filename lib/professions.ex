defmodule Professions do
  @type professionId :: integer()
  @type professionCategory :: String.t()
  @type profession :: %{id: professionId(), name: String.t(), category: professionCategory()}
  @type t :: [profession]

  defp getProfessionsByProfessionId() do
    CSVParser.parseProfessions() |> Map.new(fn p -> {p.id, p} end)
  end

  @doc ~S"""
      Return the profession category for a profession id

      ## Examples

        iex> Professions.getProfessionCategoryForProfessionId(18)
        "Tech"

        iex> Professions.getProfessionCategoryForProfessionId(31)
        "Retail"
  """
  @spec getProfessionCategoryForProfessionId(professionId()) :: professionCategory()
  def getProfessionCategoryForProfessionId(professionId) do
    getProfessionsByProfessionId()[professionId].category
  end
end
