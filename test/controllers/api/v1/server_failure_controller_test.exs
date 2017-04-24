defmodule Errorio.Api.V1.ServerFailureControllerTest do
  use Errorio.ConnCase
  import Errorio.Factory

  alias Errorio.ServerFailureTemplate
  alias Errorio.ServerFailure

  @valid_attrs build(:server_failure_request)
  @invalid_attrs %{}

  @project build(:project)

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    @project |> Repo.insert
    conn = post conn, api_v1_server_failure_template_path(conn, :create), %{"server_failure" => Poison.encode!(@valid_attrs), "token" => @project.api_key }
    assert json_response(conn, 201)#["data"]["id"]
    assert length(Errorio.Repo.all(ServerFailureTemplate)) == 1
    assert length(Errorio.Repo.all(ServerFailure)) == 1
    new_failure = Errorio.Repo.one(from x in ServerFailure, order_by: [desc: x.id], limit: 1)
    expected = %{"data" => [%{ "type" => "server_failure", "id" => new_failure.id }]}

    assert json_response(conn, 201) == expected
  end

  test "does not create resource and renders errors when data valid and project API key invalid", %{conn: conn} do
    conn = post conn, api_v1_server_failure_template_path(conn, :create), %{"server_failure" => @valid_attrs, "token" => @project.api_key }
    assert json_response(conn, 422)["errors"] !=%{}
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_server_failure_template_path(conn, :create), %{"server_failure" => @invalid_attrs, "token" => @project.api_key }
    assert json_response(conn, 422)["errors"] != %{}
  end
end
