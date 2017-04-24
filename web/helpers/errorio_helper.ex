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
    Timex.local(date)
    |> Timex.format!("%H:%M:%S %d %b %Y %:z", :strftime)
  end

  def format_date_relative(date) do
    Timex.local(date)
    |> Timex.format!("{relative}", :relative)
  end

  def sum(list, key) do
    Enum.reduce(list, 0, fn(x, acc) -> Map.get(x, key, 0) + acc end)
  end

  def truncate_string(str, truncate_length \\ 30, omit \\ "...") do
    case (String.length(str) > (truncate_length - String.length(omit))) do
      true -> "#{str |> String.slice(0, truncate_length) |> String.trim_trailing}#{omit}"
      false -> str
    end
  end

  def css_class_from_state(state) do
    case state do
      "to_do" -> "panel-danger"
      "reopened" -> "panel-danger"
      "in_progress" ->  "panel-warning"
      "to_check" ->  "panel-info"
      "done" ->  "panel-success"
      _ -> "panel-primary"
    end
  end
end
