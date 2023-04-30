defmodule CSVParserTest do
  use ExUnit.Case, async: true
  doctest CSVParser

  @professions CSVParser.parseProfessions()

  test "Parse the CSV file containing the jobs and put the result in a job list" do
    assert CSVParser.parseJobs(@professions) |> Enum.take(2) === [
             %{
               continent: :europe,
               professionCategory: "Marketing / Comm'"
             },
             %{
               continent: :europe,
               professionCategory: "Business"
             }
           ]
  end
end
