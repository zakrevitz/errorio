defmodule Errorio.Api.Structs.Failure do
  defstruct title: "UndefinedError (Errorio Api Failure)",
            request: "",
            processed_by: "",
            exception: "Something goes wrong in Server Api, investigation required",
            host: "",
            backtrace: %{},
            server: "",
            params: %{},
            session: %{},
            headers: %{},
            context: %{}
  def new(%{}=params) do
    prepare_data(params)
  end

  defp prepare_data(%{}=params) do
    %__MODULE__{
      title: fetch_title(params["errors"]),
      request: fetch_request(params),
      processed_by: fetch_processed_by(params["context"]),
      exception: fetch_exception(params["errors"]),
      host: fetch_host(params["context"]),
      backtrace: fetch_backtrace(params["errors"]),
      server: fetch_server(params["context"]),
      params: fetch_params(params["params"]),
      session: fetch_session(params["session"]),
      headers: fetch_headers(params["environment"]),
      context: fetch_context(params["context"])
    }
  end

  defp fetch_title(data) when is_list(data), do: data |> Enum.at(-1) |> Map.get("type")
  defp fetch_title(nil), do: "UndefinedError"

  defp fetch_processed_by(data) when is_map(data) do
    [data["component"], data["action"]] |> Enum.reject(&(&1 == nil)) |> Enum.join(" ")
  end
  defp fetch_processed_by(nil), do: "UndefinedError"

  defp fetch_exception(data) when is_list(data), do: data |> Enum.at(-1) |> Map.get("message")
  defp fetch_exception(_), do: "Oops, something go wrong!"

  defp fetch_host(data) when is_map(data), do: data["hostname"]
  defp fetch_host(_), do: "default_host"

  defp fetch_backtrace(data) when is_list(data), do: data |> Enum.at(-1) |> Map.get("backtrace")
  defp fetch_backtrace(_), do: %{}

  defp fetch_server(data) when is_map(data), do: data["site_name"]
  defp fetch_server(_), do: "default_server_name"

  defp fetch_params(data) when is_map(data), do: data
  defp fetch_params(_), do: %{}

  defp fetch_session(data) when is_map(data), do: data
  defp fetch_session(_), do: %{}

  defp fetch_headers(data) when is_map(data), do: data["headers"]
  defp fetch_headers(_), do: %{}

  defp fetch_context(data) when is_map(data), do: data
  defp fetch_context(_), do: %{}

  defp fetch_request(data) do
    if (data["environment"] && Map.has_key?(data["environment"], "httpMethod")), do: data["environment"]["httpMethod"] , else: "Backgroung"
    <> " "
    <> if (data["context"] && Map.has_key?(data["context"], "url")), do: data["context"]["url"], else: ""
  end

  # defp fetch_request(_), do: ""
end
