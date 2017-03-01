defmodule Errorio.ServerFailureTemplateTest do
  use Errorio.ModelCase

  alias Errorio.ServerFailureTemplate

  @valid_attrs %{md5_hash: "some content", server_failure_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ServerFailureTemplate.changeset(%ServerFailureTemplate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ServerFailureTemplate.changeset(%ServerFailureTemplate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
