# UrlShortener

## To start the server:
  * For reviewing how it works, you have two options - I recommend the `docker-compose.yml` approach:
    - Option 1:
      - Just do `make dkcbuild && make` for simple building/loading up of the app. 
      - Then go to `localhost:4000` to see the app.
      - Note: I haven't solved live reloading in this setup - so you're gonna have to refresh every time you change code.

## Run Tests:
  * `make dkctest`

## Benchmark against deployed service:
  * `make benchmark`
  * This will test against the deployed service at https://url-shortener-seungjin.fly.dev
  * It runs two tests, one for the form endpoint and another for the tiny url redirection endpoint.


    
