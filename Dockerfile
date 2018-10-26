# Dockerfile to create an environment that contains the Nix package manager.
FROM alpine

ARG NIX_VERSION
ENV NIX_VERSION ${NIX_VERSION:-2.1.3}

RUN addgroup -g 30000 -S nixbld \
    && for i in $(seq 1 30); do adduser -S -D -h /var/empty -g "Nix build user $i" -u $((30000 + i)) -G nixbld nixbld$i ; done \
    && adduser -D nixuser \
    && mkdir -m 0755 /nix && chown nixuser /nix \
    && apk add --no-cache bash \
    && rm -rf /var/cache/apk/*

USER nixuser
ENV USER=nixuser
ENV HOME="/home/nixuser"

RUN cd && wget https://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.bz2 \
    && tar xjf nix-*-x86_64-linux.tar.bz2 \
    && ~/nix-*-x86_64-linux/install \
    && rm -rf ~/nix-*-*

ENV ENV="/home/nixuser/.nix-profile/etc/profile.d/nix.sh"
RUN ln -s ${ENV} ${HOME}/.profile
SHELL ["/usr/bin/env", "bash", "-l", "-c"]
ENTRYPOINT ["/usr/bin/env", "bash", "-l", "-c"]
