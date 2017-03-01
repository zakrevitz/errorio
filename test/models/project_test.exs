defmodule Errorio.ProjectTest do
  use Errorio.ModelCase

  alias Errorio.Project

  @valid_attrs %{api_key: "some content", name: "some content", template: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
