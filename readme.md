# Description

Hi all 👋

Here is my test carried out in Elixir. This is my first time with Elixir.
It took me time to discover the language and learn the different concepts. I have a lot of questions 🙂

The sources are present in the `lib` folder and the tests in the `test` folder.

In order to provide clean code, I used few tools (formatter, `dialyzer`, test, github actions). I also tried `credo`

I've split my work into several Pull Requests. You can therefore easily see the evolution of the project in these different PRs.

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

# Scaling

Please find my solution [here](doc/scaling.md)

# Notes/Questions

- Why dialyzer does not complain?

```
  @spec test3() :: list(integer())
  def test3() do
    [%{name: "toto", brand: "toto"}] |> Enum.map(& &1)
  end
```

I noticed that a lib called `TypeCheck` exists for Elixir. Do you recommend it?

- How to properly handle errors in the Elixir application?

- I know that it would be possible to create different processes to separate the concerns.
  As this is my first time with Elixir, I really would like to discuss it with Elixir experts
  to gather feedback about the current version and understand how processes can help.
