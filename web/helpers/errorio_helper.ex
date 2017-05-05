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
    |> Timex.format!("%H:%M:%S %d %b %Y %Z", :strftime)
  end

  def format_date_relative(date) do
    Timex.local(date)
    |> Timex.format!("{relative}", :relative)
  end

  def parse_date(date) when is_binary(date), do: parse_date(date, "%d/%m/%Y")
  def parse_date(date, format) when is_binary(date) do
    case Timex.parse(date, format, :strftime) do
      {:ok, date_time} -> date_time
      {:error, _reason} -> parse_date(nil)
    end
  end
  def parse_date(_), do: Timex.to_naive_datetime(Timex.today)

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
      "to_do" -> "danger"
      "reopened" -> "danger"
      "in_progress" ->  "warning"
      "to_check" ->  "info"
      "done" ->  "success"
      _ -> "primary"
    end
  end

  def css_class_from_priority(priority) do
    case priority do
      :no_priority -> "icmn-minus2 color-success"
      :trivial -> "icmn-arrow-down16 color-success"
      :minor -> "icmn-arrow-down6 color-success"
      :major -> "icmn-arrow-up6 color-danger"
      :critical -> "icmn-arrow-up16 color-danger"
      :mega_critical -> "icmn-fire color-danger"
      :kiday_vse_i_zaymis_etim -> "icmn-gun color-danger"
    end
  end
end

