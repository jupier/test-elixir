defmodule Main.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    jobs = JobsService.getJobs(ProfessionsService.getProfessions())

    body =
      EEx.eval_file("lib/router/template/table.html.eex",
        categories: JobsService.getCategories(jobs),
        totalByCategories: JobsService.totalByCategories(jobs),
        continents: JobsService.getContinents(jobs),
        totalByContinents: JobsService.totalByContinents(jobs),
        total: JobsService.totalOfJobs(jobs),
        numberOfJobsByContinentsAndCategories:
          JobsService.getNumberOfJobsByContinentsAndCategories(jobs)
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

    Logger.info("Starting application (http://localhost:8080)...")

    Supervisor.start_link(children, opts)
  end
end
