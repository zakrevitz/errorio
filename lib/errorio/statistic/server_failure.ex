defmodule Errorio.Statistic.ServerFailure do
  def chart(project_id \\ []) do
    params = [project_id]
    query = "SELECT to_char(m.hour, 'dd/MM/YYYY'), COALESCE(c.hour_ct, 0) AS running_ct FROM(SELECT generate_series(date_trunc('day', now() - interval '60 days'), now(), '1 day') AS hour) m LEFT JOIN (SELECT date_trunc('day', server_failures.inserted_at) AS hour, count(*) AS hour_ct FROM server_failures INNER JOIN server_failure_templates ON server_failures.server_failure_template_id = server_failure_templates.id "
    if !Enum.empty?(List.flatten(params)) do
      query = query <> " WHERE server_failure_templates.project_id = $1 "
    end
    query = query <> "GROUP  BY 1) c USING (hour) ORDER  BY m.hour;"

    # Ecto.Adapters.SQL.query!(Errorio.Repo, query, List.flatten(params))
    %Postgrex.Result{rows: rows} = Ecto.Adapters.SQL.query!(Errorio.Repo, query, List.flatten(params))
    rows
  end
end
