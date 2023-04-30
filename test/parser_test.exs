defmodule CSVParserTest do
  use ExUnit.Case, async: true
  doctest CSVParser

  @professions CSVParser.parseProfessions()

  test "Parse the CSV file containing the jobs and put the result in a job list" do
    assert CSVParser.parseJobs(@professions) |> Enum.take(2) === [%{
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
  end
end
