defmodule ProfessionsTest do
  use ExUnit.Case, async: true
  doctest ProfessionsService

  @professions ProfessionsService.getProfessions()

  test "Return the profession category from a profession id" do
    assert ProfessionsService.getProfessionCategoryForProfessionId(@professions, 18) === "Tech"

    assert ProfessionsService.getProfessionCategoryForProfessionId(@professions, 31) ===
             "Retail"
  end
end
