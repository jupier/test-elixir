# Prerequisites

- Install Elixir (v1.14.4). See https://elixir-lang.org/install.html

- Validates the installation using `elixir --version`. It should return something like:

```
Erlang/OTP 25 [erts-13.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns] [dtrace]

Elixir 1.14.4 (compiled with Erlang/OTP 25)
```

- The project uses `mix` as build tool. Run `mix deps.get` to install the dependencies.

# Questions

- Why this code does compile (dialyzer does not complain)?

```
  @spec test3() :: list(integer())
  def test3() do
    [%{name: "toto", brand: "toto"}] |> Enum.map(& &1)
  end
```
