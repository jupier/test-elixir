# Prerequisites

- Install Elixir (v1.14.4). See https://elixir-lang.org/install.html

- Validates the installation using `elixir --version`. It should return something like:

```
Erlang/OTP 25 [erts-13.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns] [dtrace]

Elixir 1.14.4 (compiled with Erlang/OTP 25)
```

- The project uses `mix` as build tool. Run `mix deps.get` to install the dependencies.

- `rebar` is needed to build the project dependencies (`telemetry` used by `plug_cowboy`).
  You may need to install it by running `mix local.rebar`

# How to run the application?

- Simply run `mix run` (This command starts a web server on `:8080`)

- Open a web browser to http://localhost:8080

# How to run the tests?

- Simply run `mix test` (This command outputs the test result and the test coverage)

# How to run Dialyzer?

This project uses [Dialyzer](https://www.erlang.org/doc/man/dialyzer.html) (via https://github.com/jeremyjh/dialyxir)

You can simply run `mix dialyzer` to launch it.

# Notes/Questions

- Why this code does compile (dialyzer does not complain)?

```
  @spec test3() :: list(integer())
  def test3() do
    [%{name: "toto", brand: "toto"}] |> Enum.map(& &1)
  end
```
