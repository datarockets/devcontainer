# devcontainer

We use devcontainer to develop our fully dockerized projects.

## Prerequisites

1. Have [datarockets/dotfiles](https://github.com/datarockets/dotfiles) installed
2. Have [datarockets/dotai](https://github.com/datarockets/dotai) installed

> [!NOTE]
> Both can be skipped, but will require to tweak your `devcontainer.json`.

## Usage example

Setup devcontainer in your project from the template:

```bash
devcontainer templates apply -t ghcr.io/datarockets/devcontainer/template:latest
```

Use directly in your `devcontainer.json`:

```json
{
  "image": "ghcr.io/datarockets/devcontainer:latest",
  "features": {
    // Makes your host docker socket available in the container
    "ghcr.io/datarockets/devcontainer/feature-with-docker": {},

    // Keeps .local directory in container persistent as a volume (project 
    // level)
    "ghcr.io/datarockets/devcontainer/feature-mount-perproject-dotlocal": {},

    // Keeps some cache files in container persistent as a volume (host level)
    "ghcr.io/datarockets/devcontainer/feature-mount-permachine-caches": {},

    // Binds your overrides of dotfiles to container (dotfiles themselves are 
    // already in container)
    "ghcr.io/datarockets/devcontainer/feature-mount-dotfiles-local": {},

    // Binds your dotai files and other ai related configurations
    // It installs dotai on every container start so everything is merged with 
    // your local ai related configurations and never overrides them.
    "ghcr.io/datarockets/devcontainer/feature-mount-dotai": {},
  },
}
```
