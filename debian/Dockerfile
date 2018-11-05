# Dockerfile to create an environment that contains the Nix package manager.
FROM debian:stable-slim

ARG NIX_VERSION
ENV NIX_VERSION ${NIX_VERSION:-2.1.3}
ARG LANG
ENV LANG ${LANG:-"en_US.UTF-8"}

RUN addgroup --gid 30000 --system nixbld \
    && for i in $(seq 1 30); do adduser --system --disabled-password --home /var/empty --gecos "Nix build user $i" --uid $((30000 + i)) --ingroup nixbld nixbld$i ; done \
    && adduser --disabled-password nixuser \
    && mkdir -m 0755 /nix && chown nixuser /nix \
    && apt update && apt install -y wget bzip2 \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER nixuser
ENV USER=nixuser
ENV HOME="/home/nixuser"

RUN cd && wget https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.bz2 \
    && tar xjf nix-*-x86_64-linux.tar.bz2 \
    && ~/nix-*-x86_64-linux/install \
    && rm -rf ~/nix-*-*

ENV ENV="/home/nixuser/.nix-profile/etc/profile.d/nix.sh"
RUN echo ". ${ENV}" >> ${HOME}/.profile
# All subsequent "RUN" will use a login shell
SHELL ["/usr/bin/env", "bash", "-l", "-c"]

RUN nix-channel --add https://nixos.org/channels/nixpkgs-18.09-darwin nixpkgs \
  && nix-channel --update

# Propagate UTF8
# https://github.com/NixOS/nix/issues/599#issuecomment-153885553
# The same is hapenning with stack2nix
RUN nix-env -iA nixpkgs.glibcLocales \
    && echo "export LOCALE_ARCHIVE=$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive" >> ${HOME}/.profile

# Make sure to use "login" shell when running container
ENTRYPOINT ["/usr/bin/env", "bash", "-l", "-c"]
