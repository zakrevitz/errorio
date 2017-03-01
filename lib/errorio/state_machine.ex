defmodule Errorio.StateMachine do
  alias Errorio.Authorization
  alias Errorio.Repo

  def migrate(event, element, klass) do
    case check_event_exists(event, klass) do
      {:ok} ->
        case migrate_element(event, element, klass) do
          {:ok, migrated_element} -> {:ok, migrated_element}
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  defp check_event_exists(event, klass) do
    case Enum.member?(klass.events, event) do
      true ->
        {:ok}
      false ->
        {:error, "Undefined event #{event}"}
    end
  end

  defp migrate_element(event, element, klass) do
    migrated_element = apply(klass, event, [element])
    |> Repo.update
  end
end
