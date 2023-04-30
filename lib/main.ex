defmodule Main.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    body =
      EEx.eval_file("lib/router/template/table.html.eex",
        categories: Jobs.getCategories(),
        totalForCategories: Jobs.totalByCategories(),
        continents: Jobs.getContinents(),
        totalForContinents: Jobs.totalByContinents(),
        total: Jobs.totalOfJobs(),
        values: Jobs.getJobNumberByContinentsAndCategories()
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