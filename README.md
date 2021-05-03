# devcontainer

We use devcontainer to develop our fully dockerized projects.

It allows us to use Visual Studio Code's developing inside a container feature for project with multiple services.

## Fully dockerized projects

We use docker-compose for setting up dockerized projects. Every service of the dockerized project exists in its own container with all the dependencies (npm packages, ruby gems). If we avoid duplicating dependencies on developer's local machine it means we loose and ability to do many of the things in our IDE, like debugging or linting or formatting.

Visual Studio Code supports ["developing inside a container"](https://code.visualstudio.com/docs/remote/containers). It allows us to attach to a container and run, in example, linter right inside the container. This is one of the ways to go: you start your services with docker-compose, attach to a running container and perform debugging there, here is a [proof of concept](https://github.com/datarockets/vscode-docker-compose-poc).

This approach with attaching to different containers has a number of limitation: 1) if you have multiple services you need to open a multiple vscode windows attached to different containers to work on different services simultaneously; 2) you still will miss some of the IDE features, like git integration (we don't have git installed in service container and mounting .git folder wont work since we don't mount all the service folder in one particular service container), and embedded terminal.

Instead of attaching to service containers serparately, we add one more service "devcontainer" to the docker-compose.yml and attach to it with vscode. We mount the whole project folder with all the services to "devcontainer" as well, we also mount dependencies folders for every service so they become available and runnable in the devcontainer. It allows us to run linters and tests the same way we would do if we have all the dependencies installed on developer's machine.

See an [example](examples/ruby-api-with-spa-frontend) for a project that uses Ruby for API and [dreact](https://github.com/datarockets/dreact) for frontend.

We use official images (e.g. [node](https://hub.docker.com/_/node)) for service containers but we install compilers and interpreters using [asdf](https://asdf-vm.com/) in the devcontainer. We have to be conscious about installing the same version of compiler or interpreter in the devcontainer in order to avoid possible problems.


## Limitations

We have to use the same OS for service containers and for devcontainer, e.g. Debian Buster. This is because different OS may use different system dependencies which highly influence how we build native parts of our dependencies for different services. E.g. Alpine linux uses musl when Debian uses glibc and gem's native extensions compiled in Alpine-based container aren't runnable in Debian container.


## Tags

We have [base container](#base-container-with-dev-tools-buster) with some tools installed. You can inherit from it and install any needed compilers and interpreters additionally, using asdf.

Compiling interpreters and compilers takes some CPU time so we also have a number of pre-built containers for our stacks: [Rails API with SPA frontend](#rails-api-with-spa-frontend-node-node_version-ruby-ruby_version-buster).

### Base container with dev tools: `buster`

[ghcr.io/datarockets/devcontainer:buster](https://ghcr.io/datarockets/devcontainer:buster).

It has a number of tools for development installed: sudo, git, vim, tmux, ping. See [`Dockerfile`](Dockerfile) for more information.

You can inherit your own devcontainer from it and install any wanted dependencies you need:

```Dockerfile
ARG DOTFILES_REPO="https://github.com/datarockets/dotfiles.git"
ARG DOTFILES_INSTALL_COMMAND="RCRC=$HOME/.dotfiles/rcrc rcup"
FROM ghcr.io/datarockets/devcontainer:buster

RUN apt-get install postgresql postgresql-contrib

USER dev
SHELL ["/bin/zsh", "-ic"]

RUN asdf asdf plugin-add ruby; \
    asdf install ruby 3.0.1; \
    asdf global ruby 3.0.1
```

Having postgresql installed in the devcontainer will allow you to use `psql`.

### Rails API with SPA frontend: `node-NODE_VERSION-ruby-RUBY_VERSION-buster`

[ghcr.io/datarockets/devcontainer:node-14.16.1-ruby-3.0.1-buster](https://ghcr.io/datarockets/devcontainer:node-14.16.1-ruby-3.0.1-buster)

See the [buld.yml](.github/workflows/build.yml#L36-L37) for Ruby and Node versions available.


## Contribution

Feel free to create issues and propose pull requests.
