defmodule JobsTest do
  use ExUnit.Case, async: true

  @professions ProfessionsService.getProfessions()
  @jobs JobsService.getJobs(@professions)

  test "Return all the jobs" do
    assert @jobs |> Enum.take(2) === [
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

  test "Return the number of jobs by continents and categories" do
    assert JobsService.getNumberOfJobsByContinentsAndCategories(@jobs)
           |> Map.get(:africa) === %{
             "Admin" => 1,
             "Business" => 1,
             "Marketing / Comm'" => 1,
             "Retail" => 8,
             "Tech" => 5
           }
  end

  test "Return all the continents" do
    assert JobsService.getContinents(@jobs) === [
             :africa,
             :asia,
             :australia,
             :europe,
             :northamerica
           ]
  end

  test "Return all the categories" do
    assert JobsService.getCategories(@jobs) === [
             "Admin",
             "Business",
             "Conseil",
             "Créa",
             "Marketing / Comm'",
             "Retail",
             "Tech"
           ]
  end

  test "Total by categories" do
    assert JobsService.totalByCategories(@jobs) === %{
             "Admin" => 407,
             "Business" => 1436,
             "Conseil" => 175,
             "Créa" => 212,
             "Marketing / Comm'" => 776,
             "Retail" => 528,
             "Tech" => 1431
           }
  end

  test "Total by continents" do
    assert JobsService.totalByContinents(@jobs) === %{
             africa: 16,
             asia: 52,
             australia: 1,
             europe: 4737,
             northamerica: 159
           }
  end

  test "Total of jobs" do
    assert JobsService.totalOfJobs(@jobs) === 4965
  end
end
