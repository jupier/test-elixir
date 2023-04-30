defmodule Professions do
  @type professionId :: integer()
  @type professionCategory :: String.t()
  @type profession :: %{id: professionId(), name: String.t(), category: professionCategory()}
  @type t :: [profession]

  @spec getProfessions() :: t()
  def getProfessions() do
    CSVParser.parseProfessions()
  end
end

defmodule ProfessionsInfo do
  defp professionsByProfessionId(professions) do
    professions |> Map.new(fn p -> {p.id, p} end)
  end

  @doc ~S"""
      Return the profession category for a profession id

      ## Examples

        iex> Professions.getProfessionCategoryForProfessionId(18)
        "Tech"

        iex> Professions.getProfessionCategoryForProfessionId(31)
        "Retail"
  """
  @spec getProfessionCategoryForProfessionId(Professions.t(), Professions.professionId()) ::
          Professions.professionCategory()
  def getProfessionCategoryForProfessionId(professions, professionId) do
    professionsByProfessionId(professions)[professionId].category
  end
end
