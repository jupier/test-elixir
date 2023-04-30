defmodule Jobs do
  @type job :: %{
          professionId: integer(),
          professionCategory: Professions.professionCategory(),
          contractType: String.t(),
          name: String.t(),
          latitude: float(),
          longitude: float(),
          continent: Geo.continent()
        }
  @type t :: [job]

  @spec getJobs(Professions.t()) :: t()
  def getJobs(professions) do
    CSVParser.parseJobs(professions)
  end
end

defmodule JobsInfo do
  @doc """
      Return the number of jobs by continents and categories
  """
  @spec getNumberOfJobsByContinentsAndCategories(Jobs.t()) :: %{
          Geo.continent() => %{Professions.professionCategory() => integer()}
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
  @spec getContinents(Jobs.t()) :: [Geo.continent()]
  def getContinents(jobs) do
    jobs |> Enum.map(fn %{continent: c} -> c end) |> Enum.uniq() |> Enum.sort()
  end

  @doc """
      Return all the categories
  """
  @spec getCategories(Jobs.t()) :: [Professions.professionCategory()]
  def getCategories(jobs) do
    jobs
    |> Enum.map(fn %{professionCategory: c} -> c end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  @doc """
      Total by categories
  """
  @spec totalByCategories(Jobs.t()) :: %{Professions.professionCategory() => integer()}
  def totalByCategories(jobs) do
    categories = getCategories(jobs)

    getNumberOfJobsByContinentsAndCategories(jobs)
    |> Map.values()
    |> Enum.reduce(
      %{},
      fn value, acc ->
        Enum.reduce(categories, acc, fn category, acc2 ->
          inc = Map.get(value, category, 0)
          Map.update(acc2, category, inc, &(&1 + inc))
        end)
      end
    )
  end

  @doc """
      Total by continents
  """
  @spec totalByContinents(Jobs.t()) :: %{Geo.continent() => integer()}
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
