# build stage
FROM m.daocloud.io/ghcr.io/cargo-lambda/cargo-lambda:latest AS build-stage
WORKDIR /usr/src/kafka-producer
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo lambda build --release

RUN cargo lambda deploy
