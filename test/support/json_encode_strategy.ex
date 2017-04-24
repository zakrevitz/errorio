defmodule Errorio.JsonEncodeStrategy do
  use ExMachina.Strategy, function_name: :json_encode

  def handle_json_encode(record, _opts) do
    Poison.encode!(record)
  end
end
