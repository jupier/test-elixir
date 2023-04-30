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
      %{"id" => id, "category_name" => category} ->
        {String.to_integer(id), category}
    end
  end

  @spec transformRowIntoJob(Professions.t(), map()) :: Jobs.job()
  defp transformRowIntoJob(professions, row) do
    case row do
      %{
        "profession_id" => id,
        "office_latitude" => latitudeStr,
        "office_longitude" => longitudeStr
      } ->
        lat = String.to_float(latitudeStr)
        lon = String.to_float(longitudeStr)
        professionId = String.to_integer(id)

        %{
          professionCategory:
            ProfessionsService.getProfessionCategoryForProfessionId(professions, professionId),
          continent: Continents.getContinentForCoordinates(lat, lon)
        }
    end
  end

  @doc ~S"""

    Parse the CSV file containing the professions and put the result in a profession list

    ## Examples
      iex> Map.get(CSVParser.parseProfessions(), 17)
      "Tech"

      iex> Map.get(CSVParser.parseProfessions(), 25)
      "Admin"

      iex> Map.get(CSVParser.parseProfessions(), 4)
      "Marketing / Comm'"

  """
  @spec parseProfessions() :: Professions.t()
  def parseProfessions() do
    parseAndTransformCSVFile(
      "resources/technical-test-professions.csv",
      &transformRowIntoProfession/1
    )
    # Here Map.new creates a Map from Tuples
    |> Map.new()
  end

  @doc ~S"""

    Parse the CSV file containing the jobs and put the result in a job list

  """
  @spec parseJobs(Professions.t()) :: Jobs.t()
  def parseJobs(professions) do
    parseAndTransformCSVFile(
      "resources/technical-test-jobs.csv",
      fn row -> transformRowIntoJob(professions, row) end
    )
  end
end
