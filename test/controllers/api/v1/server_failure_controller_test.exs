defmodule Errorio.Api.V1.ServerFailureControllerTest do
  use Errorio.ConnCase

  alias Errorio.ServerFailure
  @valid_attrs %{backtrace: "some content", exception: "some content", host: "some content", params: "some content", processed_by: "some content", request: "some content", server: "some content", state: 42, title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, api_v1_server_failure_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   changeset = ServerFailure.changeset(%ServerFailure{}, @valid_attrs)
  #   server_failure = Repo.insert! changeset
  #   conn = get conn, api_v1_server_failure_path(conn, :show, server_failure)
  #   assert json_response(conn, 200)["data"] == %{"id" => server_failure.id,
  #     "title" => server_failure.title,
  #     "request" => server_failure.request,
  #     "processed_by" => server_failure.processed_by,
  #     "exception" => server_failure.exception,
  #     "host" => server_failure.host,
  #     "backtrace" => server_failure.backtrace,
  #     "server" => server_failure.server,
  #     "params" => server_failure.params,
  #     "state" => server_failure.state}
  # end

  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, api_v1_server_failure_path(conn, :show, -1)
  #   end
  # end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, api_v1_server_failure_path(conn, :create), server_failure: @valid_attrs
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(ServerFailure, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, api_v1_server_failure_path(conn, :create), server_failure: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   server_failure = Repo.insert! %ServerFailure{}
  #   conn = put conn, api_v1_server_failure_path(conn, :update, server_failure), server_failure: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(ServerFailure, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   server_failure = Repo.insert! %ServerFailure{}
  #   conn = put conn, api_v1_server_failure_path(conn, :update, server_failure), server_failure: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "deletes chosen resource", %{conn: conn} do
  #   server_failure = Repo.insert! %ServerFailure{}
  #   conn = delete conn, api_v1_server_failure_path(conn, :delete, server_failure)
  #   assert response(conn, 204)
  #   refute Repo.get(ServerFailure, server_failure.id)
  # end
end
