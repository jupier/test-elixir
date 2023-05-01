defmodule CSVParser do
  defmacro __using__(_) do
    quote do
      defp parseAndTransformCSVFile(fileName, rowFilter, rowTransform) do
        File.stream!(fileName)
        |> CSV.decode!(headers: true)
        # Keep only the rows satisfying the function passed in parameter
        # This function validates the data type
        |> Stream.filter(&rowFilter.(&1))
        |> Stream.map(&rowTransform.(&1))
        |> Enum.to_list()
      end
    end
  end
end

defmodule ProfessionParser do
  use CSVParser
  import StringUtils

  defp isProfessionRowValid?(%{"id" => id, "category_name" => category}),
    do: stringIsInteger?(id) && String.length(category) > 0

  defp isProfessionRowValid?(_),
    do: false

  @spec transformRowIntoProfession(map()) :: Professions.profession()
  defp transformRowIntoProfession(row) do
    case row do
      %{"id" => id, "category_name" => category} ->
        {String.to_integer(id), category}
    end
  end

  @doc ~S"""

    Parse the CSV file containing the professions and put the result in a map.
    A valid profession must contain a profession id and a category.
    Invalid professions are rejected.
    The keys represents the profession id and the value represents the profession's category.

    ## Examples
      iex> Map.get(ProfessionParser.parseProfessions(), 17)
      "Tech"

      iex> Map.get(ProfessionParser.parseProfessions(), 25)
      "Admin"

      iex> Map.get(ProfessionParser.parseProfessions(), 4)
      "Marketing / Comm'"

      iex> ProfessionParser.parseProfessions("test/resources/test-professions.csv")
      %{ 1 => "Tech", 2 => "Business" }

      iex> ProfessionParser.parseProfessions("test/resources/test-professions-invalid.csv")
      %{}

  """
  @spec parseProfessions(String.t()) :: Professions.t()
  def parseProfessions(fileName \\ "resources/technical-test-professions.csv") do
    parseAndTransformCSVFile(
      fileName,
      &isProfessionRowValid?/1,
      &transformRowIntoProfession/1
    )
    # Here Map.new creates a Map from Tuples
    |> Map.new()
  end
end

defmodule JobParser do
  use CSVParser
  import StringUtils

  @spec isJobRowValid?(Professions.t(), %{}) :: boolean()
  defp(
    isJobRowValid?(professions, %{
      "profession_id" => professionId,
      "office_latitude" => latitude,
      "office_longitude" => longitude
    }),
    do:
      stringIsInteger?(professionId) && stringIsFloat?(latitude) &&
        stringIsFloat?(longitude) &&
        ProfessionsService.professionIdExists?(professions, String.to_integer(professionId))
  )

  defp isJobRowValid?(_, _), do: false

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

    Parse the CSV file containing the jobs and put the result in a job list.
    A valid job must contain a valid profession id, a latitude and a longitude.
    Invalid jobs are rejected.
    The result is a list of map. Each map contains the job's continent and the profession category

    ## Examples
      iex> JobParser.parseJobs(ProfessionParser.parseProfessions())
      iex> |> Enum.take(2)
      [
        %{
          continent: :europe,
          professionCategory: "Marketing / Comm'"
        },
        %{
          continent: :europe,
          professionCategory: "Business"
        }
      ]

      iex> JobParser.parseJobs(ProfessionParser.parseProfessions(), "test/resources/test-jobs.csv")
      [
        %{
          continent: :europe,
          professionCategory: "Tech"
        }
      ]

      iex> JobParser.parseJobs(ProfessionParser.parseProfessions(), "test/resources/test-jobs-invalid.csv")
      [
      ]

  """
  @spec parseJobs(Professions.t(), String.t()) :: Jobs.t()
  def parseJobs(professions, fileName \\ "resources/technical-test-jobs.csv") do
    parseAndTransformCSVFile(
      fileName,
      fn row -> isJobRowValid?(professions, row) end,
      fn row -> transformRowIntoJob(professions, row) end
    )
  end
end
