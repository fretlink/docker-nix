# Dockerfile to create an environment that contains the Nix package manager.
FROM alpine

ARG NIX_VERSION
ENV NIX_VERSION ${NIX_VERSION:-2.3.1}
ARG LANG
ENV LANG ${LANG:-"en_US.UTF-8"}

RUN addgroup -g 30000 -S nixbld \
    && for i in $(seq 1 30); do adduser -S -D -h /var/empty -g "Nix build user $i" -u $((30000 + i)) -G nixbld nixbld$i ; done \
    && adduser -D nixuser \
    && mkdir -m 0755 /nix && chown nixuser /nix \
    && apk add --no-cache bash xz \
    && rm -rf /var/cache/apk/* \
    # sandboxing enabled by default since 2.2
    && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf

USER nixuser
ENV USER=nixuser
ENV HOME="/home/nixuser"

RUN cd && wget https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.xz \
    && tar xJf nix-*-x86_64-linux.tar.xz \
    && ~/nix-*-x86_64-linux/install \
    && rm -rf ~/nix-*-*

ENV ENV="/home/nixuser/.nix-profile/etc/profile.d/nix.sh"
RUN echo ". ${ENV}" >> ${HOME}/.profile
# All subsequent "RUN" will use a login shell
SHELL ["/usr/bin/env", "bash", "-l", "-c"]

RUN nix-channel --add https://nixos.org/channels/nixpkgs-19.09-darwin nixpkgs \
    && nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable \
    && nix-channel --update

# Propagate UTF8
# https://github.com/NixOS/nix/issues/599#issuecomment-153885553
# The same is hapenning with stack2nix
RUN nix-env -iA nixpkgs.glibcLocales \
    && echo "export LOCALE_ARCHIVE=$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive" >> ${HOME}/.profile

# Make sure to use "login" shell when running container
ENTRYPOINT ["/usr/bin/env", "bash", "-l", "-c"]
