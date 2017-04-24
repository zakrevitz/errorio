defmodule Errorio.ServerFailureTest do
  use Errorio.ModelCase
  import Errorio.Factory
  alias Errorio.ServerFailure

  @valid_attrs params_for(:server_failure)
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ServerFailure.changeset(%ServerFailure{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ServerFailure.changeset(%ServerFailure{}, @invalid_attrs)
    refute changeset.valid?
  end
end
