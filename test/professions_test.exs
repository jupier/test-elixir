defmodule ProfessionsTest do
  use ExUnit.Case, async: true
  doctest ProfessionsService

  @professions ProfessionsService.getProfessions()

  test "Return the profession" do
    assert Map.get(ProfessionsService.getProfessions(), 17) === "Tech"

    assert Map.get(ProfessionsService.getProfessions(), 25) === "Admin"
  end

  test "Return the profession category from a profession id" do
    assert ProfessionsService.getProfessionCategoryForProfessionId(@professions, 18) === "Tech"

    assert ProfessionsService.getProfessionCategoryForProfessionId(@professions, 31) ===
             "Retail"
  end

  test "Return true if the profession id exists" do
    assert ProfessionsService.professionIdExists?(@professions, 18) === true

    assert ProfessionsService.professionIdExists?(@professions, 666) === false
  end
end
