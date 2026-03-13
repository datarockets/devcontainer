FROM debian:trixie-slim
ARG TARGETARCH

RUN <<-EOF
	# install system dependencies
	set -eux

	apt-get update
	apt-get -y upgrade

	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		build-essential procps curl file git ca-certificates \
		locales sudo zsh

	dpkg-reconfigure -f noninteractive tzdata
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	echo 'LANG="en_US.UTF-8"' > /etc/default/locale
	dpkg-reconfigure --frontend=noninteractive locales
	update-locale LANG=en_US.UTF-8

	apt-get clean
	rm -rf /var/lib/{apt,dpkg,cache,log}/*
	EOF

ARG USERNAME=dev
ARG HOST_UID=1000
RUN <<-EOF
	# add user
	set -eux

	useradd -s /bin/zsh -m -u ${HOST_UID} ${USERNAME}
	echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}
	chmod 0440 /etc/sudoers.d/${USERNAME}
	mkdir -p /home/${USERNAME}/.ssh && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh

	groupadd docker
	usermod -aG docker ${USERNAME}
	EOF

USER ${USERNAME}
ENV HOME=/home/${USERNAME}
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
WORKDIR ${HOME}

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

RUN <<-EOF
	# install tools
	set -eux

	brew install \
		iputils net-tools \
		docker docker-buildx docker-compose \
		rcm \
		tmux neovim openssh \
		jq fzf ripgrep fd \
		opentofu gcloud-cli kubectl kubectl-cnpg

	gcloud components install gke-gcloud-auth-plugin
	EOF

ARG DOTFILES_REPO="https://github.com/datarockets/dotfiles.git"
ARG DOTFILES_INSTALL_COMMAND="RCRC=${HOME}/.dotfiles/rcrc rcup"
RUN <<-EOF
	# install dotfiles
	set -eux
	git clone $DOTFILES_REPO ~/.dotfiles
	eval "${DOTFILES_INSTALL_COMMAND}"

	echo "[[ -f ~/.zshrc.devcontainer ]] && source ~/.zshrc.devcontainer"  > ~/.zshrc.local

	mkdir -p ${HOME}/.bin
	echo 'export PS1="[dev] ${PS1}"' >> ${HOME}/.zshrc.devcontainer
	echo 'export PATH="${HOME}/.bin:${HOME}/.local/bin:${PATH}"' >> ${HOME}/.zshrc.devcontainer
	EOF

RUN <<-EOF
	# install node and prepare HOME
	set -eux

	brew install node@24
	brew link node@24

	brew install oven-sh/bun/bun

	mkdir -p ${HOME}/.dotai
	mkdir -p ${HOME}/.config
	mkdir -p ${HOME}/.local
	mkdir -p ${HOME}/.kube
	mkdir -p ${HOME}/.bun/install/cache
	mkdir -p ${HOME}/.pnpm-store
	mkdir -p ${HOME}/.cache/opencode
	mkdir -p ${HOME}/.cache/oh-my-opencode

	mkdir -p ~/.docker
	echo '{"cliPluginsExtraDirs": ["/home/linuxbrew/.linuxbrew/lib/docker/cli-plugins"]}' > ~/.docker/config.json

	# Add homebrew and bun to PATH
	echo 'export PATH="${PATH}:/home/linuxbrew/.linuxbrew/share/google-cloud-sdk/bin:/home/${USERNAME}/.bun/bin"' >> ${HOME}/.zshrc.devcontainer
	EOF

ENV CLAUDE_CONFIG_DIR="${HOME}/.config/claude"
ENV OPENCODE_EXPERIMENTAL_MARKDOWN=true

RUN <<-EOF
	# install agentic tools
	set -eux

	bun install -g @sourcegraph/amp opencode-ai @anthropic-ai/claude-code
	EOF

COPY --chmod=755 bin/xclip /usr/local/bin/xclip

ENV IS_DEVCONTAINER="1"

CMD ["sleep", "infinity"]
