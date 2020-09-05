# cannot produce proc-macro for `pin-project-internal v0.4.16` as the target `x86_64-unknown-linux-musl` does not support these crate types
# FROM rust:alpine as builder 
FROM rust:stretch as builder
WORKDIR /usr/src/myapp
COPY . .

# RUN cargo install --path .
RUN cargo install \
    wasm-pack \
    cargo-make \
    simple-http-server

RUN cargo make build
# RUN cargo build --release

FROM rust:slim-stretch
COPY --from=builder /usr/src/myapp/static /app/static
COPY --from=builder /usr/src/myapp/index.html /app/static/index.html
WORKDIR /app
ENTRYPOINT ["cargo", "make", "serve"]