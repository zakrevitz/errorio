defmodule Errorio.ServerFailureTest do
  use Errorio.ModelCase

  alias Errorio.ServerFailure

  @valid_attrs %{backtrace: "some content", exception: "some content", host: "some content", params: "some content", processed_by: "some content", request: "some content", server: "some content", state: 42, title: "some content"}
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
