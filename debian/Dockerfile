# Dockerfile to create an environment that contains the Nix package manager.
FROM debian:stable-slim

ARG NIX_VERSION
ENV NIX_VERSION ${NIX_VERSION:-2.3.9}
ARG LANG
ENV LANG ${LANG:-"en_US.UTF-8"}

RUN addgroup --gid 30000 --system nixbld \
    && for i in $(seq 1 30); do adduser --system --disabled-password --home /var/empty --gecos "Nix build user $i" --uid $((30000 + i)) --ingroup nixbld nixbld$i ; done \
    && adduser --disabled-password nixuser \
    && mkdir -m 0755 /nix && chown nixuser /nix \
    && apt update && apt install -y wget xz-utils \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /etc/nix && touch /etc/nix/nix.conf

USER nixuser
ENV USER=nixuser
ENV HOME="/home/nixuser"
ENV NIX_SYSTEM_PATH="/nix/var/nix/profiles/system"
ENV NIX_PROFILE="$HOME/nix-envs"

RUN cd && wget https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.xz \
    && tar xJf nix-*-x86_64-linux.tar.xz \
    && NIX_PROFILE="$NIX_SYSTEM_PATH" ~/nix-*-x86_64-linux/install \
    && rm -rf ~/nix-*-*

# All subsequent "RUN" will use a login shell
SHELL ["/usr/bin/env", "bash", "-l", "-c"]

# Create bash profile
COPY --chown=nixuser:nixuser files/.profile ${HOME}/.profile

RUN nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs \
    && nix-channel --update

# Propagate UTF8
# https://github.com/NixOS/nix/issues/599#issuecomment-153885553
# The same is hapenning with stack2nix
RUN nix-env -p "$NIX_SYSTEM_PATH" -iA nixpkgs.glibcLocales

# < Nix context as a volume
# We want to be able to define /nix/store as a volume
VOLUME ["/nix"]
# />

# Make sure to use "login" shell when running container
ENTRYPOINT ["/usr/bin/env", "bash", "-l", "-c"]
