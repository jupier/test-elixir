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
  @type jobs :: [job]

  defp getJobs() do
    CSVParser.parseJobs()
  end

  @doc ~S"""
      Return the number of jobs by continents and categories

      ## Examples

        iex> Jobs.getJobNumberByContinentsAndCategories()
        iex> |> Map.get(:africa)
        %{"Admin" => 1, "Business" => 1, "Marketing / Comm'" => 1, "Retail" => 8, "Tech" => 5}

  """
  @spec getJobNumberByContinentsAndCategories() :: %{
          Geo.continent() => %{Professions.professionCategory() => integer()}
        }
  def getJobNumberByContinentsAndCategories() do
    getJobs()
    |> Enum.reduce(%{}, fn %{continent: continent, professionCategory: category}, acc ->
      categories = Map.get(acc, continent, %{}) |> Map.update(category, 1, &(&1 + 1))
      Map.put(acc, continent, categories)
    end)
  end

  @doc ~S"""
      Return all the continents

      ## Examples

        iex> Jobs.getContinents()
        [:africa, :asia, :australia, :europe, :northamerica]
  """
  @spec getContinents() :: [Geo.continent()]
  def getContinents() do
    getJobs() |> Enum.map(fn %{continent: c} -> c end) |> Enum.uniq() |> Enum.sort()
  end

  @doc ~S"""
      Return all the categories

      ## Examples

        iex> Jobs.getCategories()
        ["Admin", "Business", "Conseil", "Créa", "Marketing / Comm'", "Retail", "Tech"]
  """
  @spec getCategories() :: [Professions.professionCategory()]
  def getCategories() do
    getJobs()
    |> Enum.map(fn %{professionCategory: c} -> c end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  @doc ~S"""
      Total by categories

      ## Examples

        iex> Jobs.totalByCategories()
        %{"Admin" => 407, "Business" => 1436, "Conseil" => 175, "Créa" => 212, "Marketing / Comm'" => 776, "Retail" => 528, "Tech" => 1431}
  """
  @spec totalByCategories() :: %{Professions.professionCategory() => integer()}
  def totalByCategories() do
    categories = getCategories()

    getJobNumberByContinentsAndCategories()
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

  @doc ~S"""
      Total by continents

      ## Examples

        iex> Jobs.totalByContinents()
        %{africa: 16, asia: 52, australia: 1, europe: 4737, northamerica: 159}
  """
  @spec totalByContinents() :: %{Geo.continent() => integer()}
  def totalByContinents() do
    getJobNumberByContinentsAndCategories()
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      sum = Map.values(v) |> Enum.sum()
      Map.update(acc, k, sum, &(&1 + sum))
    end)
  end

  @doc ~S"""
      Total of jobs

      ## Examples

        iex> Jobs.totalOfJobs()
        4965
  """
  @spec totalOfJobs() :: integer()
  def totalOfJobs() do
    totalByContinents() |> Map.values() |> Enum.sum()
  end
end
