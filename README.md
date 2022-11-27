# UrlShortener

To start your Phoenix server:
  * For reviewing how it works, you have two options - I recommend the `docker-compose.yml` approach:
    - Option 1:
      - Just do `make dkcbuild && make dkcup` for simple building/loading up of the app. 
      - Then go to `localhost:4000` to see the app.
      - Note: I haven't solved live reloading in this setup - so you're gonna have to refresh every time you change code.
    - Option 2:
      - For when you do have `asdf` installed, and would like to jump/tweak code, and use dockerized postgres (from `docker-compose.yml`) - please do `asdf install` to install the Elixir/Erlang versions in `.tool-versions`.
      - Then do: `make local_with_docker_db`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

