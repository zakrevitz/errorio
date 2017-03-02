defmodule Errorio.ErrorioHelper do
  use Timex

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

  def format_date(date) do
    Timex.format!(date, "%H:%M:%S %d %b %Y", :strftime)
  end

  def format_date_relative(date) do
    Timex.format!(date, "{relative}", :relative)
  end
end
