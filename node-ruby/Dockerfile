ARG BASE_TAG
FROM ghcr.io/datarockets/devcontainer:${BASE_TAG}

USER dev
SHELL ["/bin/zsh", "-ic"]

ARG NODE_VERSION
RUN set -eux; \
    asdf plugin-add nodejs; \
    asdf install nodejs ${NODE_VERSION}; \
    asdf global nodejs ${NODE_VERSION}

ARG RUBY_VERSION
RUN set -eux; \
    asdf plugin-add ruby; \
    asdf install ruby ${RUBY_VERSION}; \
    asdf global ruby ${RUBY_VERSION}
