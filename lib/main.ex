defmodule Main.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    jobs = Jobs.getJobs()

    body =
      EEx.eval_file("lib/router/template/table.html.eex",
        categories: JobsInfo.getCategories(jobs),
        totalForCategories: JobsInfo.totalByCategories(jobs),
        continents: JobsInfo.getContinents(jobs),
        totalForContinents: JobsInfo.totalByContinents(jobs),
        total: JobsInfo.totalOfJobs(jobs),
        values: JobsInfo.getJobNumberByContinentsAndCategories(jobs)
      )

    send_resp(conn, 200, body)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

defmodule Main.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Main.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: Main.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
