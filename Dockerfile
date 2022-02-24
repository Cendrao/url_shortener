FROM elixir:1.13.3

# APT update and install
RUN apt update
RUN apt install -y build-essential

# Nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install -y nodejs

WORKDIR /app

# Project Dependencies
COPY mix.exs mix.exs
COPY mix.lock mix.lock

RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force

# App
COPY . /app

EXPOSE 4000

CMD ["mix", "phx.server"]
