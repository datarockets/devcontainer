ARG BASE_TAG
FROM ghcr.io/datarockets/devcontainer:${BASE_TAG}

USER dev
SHELL ["/bin/zsh", "-ic"]

ARG ELIXIR_VERSION
RUN set -eux; \
    asdf plugin-add elixir; \
    asdf install elixir ${ELIXIR_VERSION}; \
    asdf global elixir ${ELIXIR_VERSION}

ARG NODE_VERSION
RUN set -eux; \
    asdf plugin-add nodejs; \
    asdf install nodejs ${NODE_VERSION}; \
    asdf global nodejs ${NODE_VERSION}
