# about

a project to develop my rust skills

https://news.ycombinator.com/item?id=24120311 > http://www.sheshbabu.com/posts/rust-wasm-yew-single-page-application/

i'm tracking my progress here: https://todo.sr.ht/~aaronkelly/webdev/8

# usage

see `.aliases`

# about the dockerfile

There is no command in Rust to pre-build dependencies, so that would mean:
- the dependency compilation stage could not be pre-built and cached
- any updates to the files in `./src` would trigger a full recompilation of the
dependencies

The solution is to add a dummy `./src/lib.rs` file in order to get the
dependencies built and get that stage cached in Docker.
