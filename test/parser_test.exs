defmodule ProfessionParserTest do
  use ExUnit.Case, async: true
  doctest ProfessionParser

  test "Fail if the file is not found" do
    assert_raise File.Error, "could not stream \"noop\": no such file or directory", fn ->
      ProfessionParser.parseProfessions("noop")
    end
  end
end

defmodule JobParserTest do
  use ExUnit.Case, async: true

  doctest JobParser

  @professions ProfessionParser.parseProfessions()

  test "Fail if the file is not found" do
    assert_raise File.Error, "could not stream \"noop\": no such file or directory", fn ->
      JobParser.parseJobs(@professions, "noop")
    end
  end
end
