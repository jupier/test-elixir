defmodule Jobs do
  @type job :: %{
          professionCategory: Professions.professionCategory(),
          continent: Continents.continent()
        }
  @type t :: [job]
end

defmodule JobsService do
  @doc """
    Return all the jobs
  """
  @spec getJobs(Professions.t()) :: Jobs.t()
  def getJobs(professions) do
    JobParser.parseJobs(professions)
  end

  @doc """
      Return the number of jobs by continents and categories
  """
  @spec getNumberOfJobsByContinentsAndCategories(Jobs.t()) :: %{
          Continents.continent() => %{Professions.professionCategory() => integer()}
        }
  def getNumberOfJobsByContinentsAndCategories(jobs) do
    jobs
    |> Enum.reduce(%{}, fn %{continent: continent, professionCategory: category}, acc ->
      categories = Map.get(acc, continent, %{}) |> Map.update(category, 1, &(&1 + 1))
      Map.put(acc, continent, categories)
    end)
  end

  @doc """
      Return all the continents
  """
  @spec getContinents(Jobs.t()) :: [Continents.continent()]
  def getContinents(jobs) do
    jobs
    |> Enum.reduce(MapSet.new(), fn %{continent: c}, acc -> MapSet.put(acc, c) end)
    |> Enum.sort()
  end

  @doc """
      Return all the categories
  """
  @spec getCategories(Jobs.t()) :: [Professions.professionCategory()]
  def getCategories(jobs) do
    jobs
    |> Enum.reduce(MapSet.new(), fn %{professionCategory: c}, acc -> MapSet.put(acc, c) end)
    |> Enum.sort()
  end

  @doc """
      Total by categories
  """
  @spec totalByCategories(Jobs.t()) :: %{Professions.professionCategory() => integer()}
  def totalByCategories(jobs) do
    getNumberOfJobsByContinentsAndCategories(jobs)
    |> Enum.reduce(%{}, fn {_, v}, acc -> Map.merge(v, acc, fn _, v1, v2 -> v1 + v2 end) end)
  end

  @doc """
      Total by continents
  """
  @spec totalByContinents(Jobs.t()) :: %{Continents.continent() => integer()}
  def totalByContinents(jobs) do
    getNumberOfJobsByContinentsAndCategories(jobs)
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      sum = Map.values(v) |> Enum.sum()
      Map.update(acc, k, sum, &(&1 + sum))
    end)
  end

  @doc """
      Total of jobs
  """
  @spec totalOfJobs(Jobs.t()) :: integer()
  def totalOfJobs(jobs) do
    totalByContinents(jobs) |> Map.values() |> Enum.sum()
  end
end
