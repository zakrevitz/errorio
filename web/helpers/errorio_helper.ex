defmodule Errorio.ErrorioHelper do
  def humanize_atom(atom) do
    case is_atom(atom) do
      :true ->
        atom
        |> Atom.to_string
        |> String.replace("_", " ")
      _ ->
        atom
    end
  end
end
