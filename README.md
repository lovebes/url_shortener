# UrlShortener

## To start your Phoenix server:
  * For reviewing how it works, you have two options - I recommend the `docker-compose.yml` approach:
    - Option 1 - You need Docker:
      - Just do `make dkcbuild && make dkcup` for simple building/loading up of the app. 
      - Then go to `localhost:4000` to see the app.
      - Note: I haven't solved live reloading in this setup - so you're gonna have to refresh every time you change code.
      - This boots up BOTH the server code and Postgres together inside Docker, so nothing else to install.
    - Option 2:
      - For when you do have `asdf` installed, and would like to jump/tweak code, and use dockerized postgres (from `docker-compose.yml`) - please do `asdf install` to install the Elixir/Erlang versions in `.tool-versions`.
      - Install dependencies with `mix deps.get`
      - Create and migrate your database with `mix ecto.setup`
      - Then do: `make`, which boots up dockerized Postgres with locally starting Phoenix server.
## Run Tests (dockerized):
  * `make dkctest`

## Benchmark against deployed service (dockerized):
  * `make benchmark`
  * This will test against the deployed service at https://url-shortener-seungjin.fly.dev
  * It runs two tests, one for the form endpoint and another for the tiny url redirection endpoint.
  * This is why you'll see a hit count that is in the hundreds in: https://url-shortener-seungjin.fly.dev/stats

## Backend Architecture/Code Notes:
This is based off of a Phoenix 1.7 scaffolded mix project. 
Core of the code base is in `UrlShortener.TinyUrls` context module and associated modules.

The algorithm to create shortened url is via the primary key of the table `tiny_urls`,
where a transactioned series of get-or-insert SQL commands are done, where upon successful insertion,
another update is made to use the index of the new row, converting it to a hex digit, and setting that as the 
short url path.

This pushes the responsibility of the enforcement of 1-to-1 mapping of short url to the url down to Postgres.
We'd be simply using the PK integer id to be the source of the short URL, preventing any collisions.

We'd also need to guarantee the URL stored is unique. Comparing by shortened URL is not going to work because
that hinges on it being already inserted. Also, relying on variable text for unique constraint check is not
ideal. Therefore, a MD5 hash string of the actual URL is stored, and used for comparison of existence.

As noted in the Project Exercise outline, no security measure was considered, nor user sessions maintained,
other than default operations of Phoenix.

## CI/CD Notes
This is hooked into GitHub Actions of private repo: https://github.com/lovebes/url_shortener
The CI piece runs Dialyzer, Credo, and Tests.
The CD piece deploys the code to Fly.io: https://url-shortener-seungjin.fly.dev/

## Frontend Notes:
* /: LiveView that takes in the URL in a form
* /:shortened_url : Controller that will:
  - do a look up and find the URL
  - increment the Hit Count of the URL
  - broadcasts PubSub message that hit count has been updated
* /stats: LiveView
  - lists out the stored URLs
  - subscribes PubSub message, and refreshes URL list
* /export: Controller that downloads the CSV of the list of URLs

