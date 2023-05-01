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
    ProfessionParser.parseProfessions()
  end

  @doc """
      Return the profession category for a profession id
  """
  @spec getProfessionCategoryForProfessionId(Professions.t(), Professions.professionId()) ::
          Professions.professionCategory()
  def getProfessionCategoryForProfessionId(professions, professionId) do
    case professions do
      %{^professionId => category} ->
        category
    end
  end

  @spec professionIdExists?(Professions.t(), Professions.professionId()) :: boolean()
  def(professionIdExists?(professions, professionId)) do
    case professions do
      %{^professionId => _} -> true
      _ -> false
    end
  end
end
