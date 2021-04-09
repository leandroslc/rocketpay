<h1 align="center">Rocketpay</h1>

<p align="center">
  Uma API web de demonstração para criar e operar contas bancárias simples.
</p>

<p align="center">
  <em>
    Construído durante a <u>Next Level Week 4</u> da <a href="https://rocketseat.com.br/">Rocketseat</a>. 🚀
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

## :book: Propósito
Um repositório para experimentação e estudo com Elixir usando Phoenix, Ecto e muitas outras ferramentas.

## :sparkles: Recursos
- Operações de depósito, saque e transação de contas.
- Registro e autenticação de usuários.
- Authenticação usando _Bearer authentication_.

**[Veja a lista de rotas](./docs/endpoints.md)**.

## :rocket: Iniciando
- Instale o [Elixir](https://elixir-lang.org).
- Instale o [Phoenix](https://www.phoenixframework.org).
- Configure um servidor [PostgreSQL](https://www.postgresql.org). Caso contrário, se estiver usando docker, você pode apenas executar `docker-compose up db`.
- Instale as dependências com `mix deps.get`.
- Crie e execute as migrações do banco de dados com `mix ecto.setup`.
- Inicie o servidor com `mix phx.server`.

## :package: Usando um container Docker
Se você não deseja configurar um ambiente Elixir, você pode se beneficiar usando o [Remote Containers do Visual Studio Code](https://code.visualstudio.com/docs/remote/containers).

## :memo: Referências
- [Docs e guias do framework Phoenix](https://hexdocs.pm/phoenix)
- [Referência do Ecto](https://hexdocs.pm/ecto)
