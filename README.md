Translations: [pt-BR](./docs/README-pt-BR.md)

<h1 align="center">Rocketpay</h1>

<p align="center">
  A sample web API to create and operate simple bank accounts.
</p>

<p align="center">
  <em>
    Built during the <u>Next Level Week 4</u> by <a href="https://rocketseat.com.br/">Rocketseat</a>. 🚀
  </em>
</p>

<div align="center">
  <a href="https://github.com/leandroslc/rocketpay/actions?query=workflow%3ABuild">
    <img src="https://github.com/leandroslc/rocketpay/workflows/Build/badge.svg" alt="Build status" />
  </a>
  <a href="https://codecov.io/gh/leandroslc/rocketpay">
    <img src="https://codecov.io/gh/leandroslc/rocketpay/branch/main/graph/badge.svg?token=MOB68asR04" alt="Code coverage status"/>
  </a>
  <img src="https://img.shields.io/badge/NLW-%231-8257e6.svg" alt="NLW #4" />
</div>

## :book: Purpose
A repository to experiment with Elixir using Phoenix, Ecto and many other tools.

## :sparkles: Features
- Account deposit, withdraw and transaction operations.
- User registration and authentication.
- Bearer (token) authentication.

**[See the list of endpoints](./docs/endpoints.md)**.

## :rocket: Getting started
- Install [Elixir](https://elixir-lang.org).
- Install [Phoenix](https://www.phoenixframework.org).
- Setup a [PostgreSQL](https://www.postgresql.org) server. If using docker, you can just run `docker-compose up db` instead.
- Install dependencies with `mix deps.get`.
- Create and migrate the database with `mix ecto.setup`.
- Start the server with `mix phx.server`.

## :package: Using a Docker container
If you do not want to setup an Elixir environment, you may benefit from using [Visual Studio Code's Remote Containers](https://code.visualstudio.com/docs/remote/containers).

## :memo: References
- [Phoenix famework docs and guides](https://hexdocs.pm/phoenix)
- [Ecto reference](https://hexdocs.pm/ecto)
