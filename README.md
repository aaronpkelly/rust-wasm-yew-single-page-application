# demo

It's on Vultr: http://95.179.158.61:80

# about

a project to develop my rust skills

https://news.ycombinator.com/item?id=24120311 > http://www.sheshbabu.com/posts/rust-wasm-yew-single-page-application/

i'm tracking my progress here: https://todo.sr.ht/~aaronkelly/webdev/8

# usage

see `.aliases` for building and running the dockerfiles

go to `http://localhost/` when the container is running

# about the dockerfile

There have been optimisations made to get this image building fast.

There is no command in Rust to pre-build dependencies, so that means:

- the dependency compilation stage can not be pre-built and cached
- any updates to the files in `./src` would trigger a full recompilation of the
dependencies

The solution is to create a dummy `./src/lib.rs` during the docker build phase,
in order to get the dependencies built and get that stage cached in Docker.

Currently I'm not using `cargo build --release`, so I think there's even more
optimiations that can be made around this.

This is a good guide: https://shaneutt.com/blog/rust-fast-small-docker-image-builds/

## pushing directly to hub.docker.com

I was building the image on builds.sr.ht and directly pushing the image to hub.docker.com, but I changed this to publish to gitlab, in order to test digitalocean's app platform... but they weren't able to host this project properly (i tried to host it as static, but it needs to pull in a .wasm file, which it wasn't able to do). Maybe I have to pay EUR5 a month to host a dynamic website instead.

Anyway, if you want the build block for pushing directly to hub.docker.com once more, here it is, it's pretty standard:

```
- setup-docker: |-
    sudo service docker start && \
            sudo addgroup $(id -u -n) docker && \
            ping www.ddg.gg -c 5 -w 5 || true
- build-image: |-
    cd "$REPO_NAME"
    docker build -t "$DOCKER_HUB_USER"/"$REPO_NAME" .
- push-to-dockerhub: |-
    docker login --username "$DOCKER_HUB_USER" \
      --password $(cat ~/DOCKER_HUB_PASS)
    docker push "$DOCKER_HUB_USER"/"$REPO_NAME"
```
