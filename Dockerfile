ARG MIX_ENV="prod"
ARG BUILDER_IMAGE="hexpm/elixir:1.14.2-erlang-25.1.2-debian-bullseye-20221004-slim"
ARG RUNNER_IMAGE="debian:bullseye-20221114-slim"

# build stage
FROM ${BUILDER_IMAGE} AS builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# sets work dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# copy compile configuration files
RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/

# compile dependencies
RUN mix deps.compile

# copy assets
COPY priv priv
COPY assets assets

# Compile assets
RUN mix assets.deploy

# compile project
COPY lib lib
RUN mix compile

# copy runtime configuration file
COPY config/runtime.exs config/

# assemble release
RUN mix release

# app stage
FROM ${RUNNER_IMAGE} AS app

ARG MIX_ENV

# install runtime dependencies
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# Appended by flyctl
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"

ENV USER="elixir"

WORKDIR "/app"
RUN chown nobody /app

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/prod/rel ./

USER nobody

# Create a symlink to the command that starts your application. This is required
# since the release directory and start up script are named after the
# application, and we don't know that name.
RUN set -eux; \
  ln -nfs /app/$(basename *)/bin/$(basename *) /app/entry

CMD /app/entry start
