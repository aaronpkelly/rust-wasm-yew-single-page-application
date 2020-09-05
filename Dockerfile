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

# compilation takes forever and the image is HUGE so I'm trying to just
# copy the static website WASM files + a index.html
# FROM rust:slim-stretch
FROM nginx
COPY --from=builder /usr/src/myapp/static /usr/share/nginx/html
COPY --from=builder /usr/src/myapp/index.html /usr/share/nginx/html/index.html
WORKDIR /app
ENTRYPOINT ["nginx"]