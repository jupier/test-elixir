defmodule CSVParser do
  @doc ~S"""

    Check if the map contains a blank string

    ## Examples

      iex> CSVParser.isAnyKeyBlank(%{string: "test", blank: ""})
      true

      iex> CSVParser.isAnyKeyBlank(%{string: "string containing space", notBlank: "test"})
      false

      iex> CSVParser.isAnyKeyBlank(%{})
      false

  """
  def isAnyKeyBlank(map) do
    Enum.any?(Map.values(map), fn str ->
      isBlank = String.length(str) === 0
      isBlank
    end)
  end

  defp parseAndTransformCSVFile(fileName, func) do
    File.stream!(fileName)
    |> CSV.decode!(headers: true)
    # Reject all the rows containing a blank value
    # Not sure if it's a good idea, but that was necessary to properly
    # convert the value in integer or float
    |> Stream.reject(&isAnyKeyBlank(&1))
    |> Stream.map(&func.(&1))
    |> Enum.to_list()
  end

  @spec transformRowIntoProfession(map()) :: Professions.profession()
  defp transformRowIntoProfession(row) do
    case row do
      %{"id" => id, "name" => name, "category_name" => category} ->
        %{id: String.to_integer(id), name: name, category: category}
    end
  end

  @spec transformRowIntoJob(map()) :: Jobs.job()
  defp transformRowIntoJob(row) do
    case row do
      %{
        "profession_id" => id,
        "contract_type" => contractType,
        "name" => name,
        "office_latitude" => latitudeStr,
        "office_longitude" => longitudeStr
      } ->
        lat = String.to_float(latitudeStr)
        lon = String.to_float(longitudeStr)
        professionId = String.to_integer(id)

        %{
          professionId: professionId,
          professionCategory: Professions.getProfessionCategoryForProfessionId(professionId),
          contractType: contractType,
          name: name,
          latitude: lat,
          longitude: lon,
          continent: Geo.getContinentForCoordinates(lat, lon)
        }
    end
  end

  @doc ~S"""

    Parse the CSV file containing the professions and put the result in a profession list

    ## Examples
      iex> CSVParser.parseProfessions()
      iex> |> Enum.take(2)
      [%{
        id: 17,
        name: "Devops / Infrastructure",
        category: "Tech"
      },
      %{
        id: 24,
        name: "Compta / Contrôle de Gestion",
        category: "Admin"
      }]
  """
  @spec parseProfessions() :: Professions.professions()
  def parseProfessions() do
    parseAndTransformCSVFile(
      "resources/technical-test-professions.csv",
      &transformRowIntoProfession/1
    )
  end

  @doc ~S"""

    Parse the CSV file containing the jobs and put the result in a job list

    ## Examples

      iex> CSVParser.parseJobs()
      iex> |> Enum.take(2)
      [%{
        contractType: "INTERNSHIP",
        latitude: 48.1392154,
        longitude: 11.5781413,
        name: "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)",
        professionId: 7,
        continent: :europe,
        professionCategory: "Marketing / Comm'"
      },
      %{
        contractType: "INTERNSHIP",
        latitude: 48.885247,
        longitude: 2.3566441,
        name: "Bras droit de la fondatrice",
        professionId: 5,
        continent: :europe,
        professionCategory: "Business"
      }]
  """
  @spec parseJobs() :: Jobs.jobs()
  def parseJobs() do
    parseAndTransformCSVFile(
      "resources/technical-test-jobs.csv",
      &transformRowIntoJob/1
    )
  end
end
