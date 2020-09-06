# cannot produce proc-macro for `pin-project-internal v0.4.16` as the target `x86_64-unknown-linux-musl` does not support these crate types
# FROM rust:alpine as builder 
FROM rust:stretch as builder
WORKDIR /usr/src/myapp

RUN cargo install \
    wasm-pack \
    cargo-make \
    simple-http-server

# While we’re waiting on a --dependencies-only build options for cargo,
# we can overcome this problem by changing our Dockerfile to have a default
# src/main.rs with which the dependencies are built before we COPY any of our code into the build
COPY Cargo.toml .
COPY Makefile.toml .
RUN mkdir src
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/lib.rs
RUN cargo make

# copy the real source files 
COPY src src
COPY index.html index.html
RUN cargo make

# copy the built outputs into a much lighter nginx image
FROM nginx
COPY --from=builder /usr/src/myapp/static /usr/share/nginx/html
COPY --from=builder /usr/src/myapp/index.html /usr/share/nginx/html/index.html
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
