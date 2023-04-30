defmodule Professions do
  @type professionId :: integer()
  @type professionCategory :: String.t()
  @type profession :: {professionId(), professionCategory()}
  @type t :: %{professionId() => professionCategory()}
end

defmodule ProfessionsService do
  @doc """
    Return all the professions
  """
  @spec getProfessions() :: Professions.t()
  def getProfessions() do
    CSVParser.parseProfessions()
  end

  @doc """
      Return the profession category for a profession id
  """
  @spec getProfessionCategoryForProfessionId(Professions.t(), Professions.professionId()) ::
          Professions.professionCategory()
  def getProfessionCategoryForProfessionId(professions, professionId) do
    professions[professionId]
  end
end
