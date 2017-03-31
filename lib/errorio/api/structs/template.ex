defmodule Errorio.Api.Structs.Template do
  @derive [Poison.Encoder]
  defstruct md5_hash: "1234567890",
            title: "UndefinedError(Errorio API failure)",
            processed_by: "undefined#undefined"
end
