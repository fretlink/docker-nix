#!/usr/bin/env bash

# Copy initial saved nix context if the /nix is empty
[ ! "$(ls -A /nix)" ] && cp -R ~/initial-nix/* /nix/

# Source nix environment
nix_profile="/home/nixuser/.nix-profile/etc/profile.d/nix.sh"
# shellcheck source=/home/nixuser/.nix-profile/etc/profile.d/nix.sh
[ -e "${nix_profile}" ] && . "${nix_profile}"

# Propagate UTF8
# https://github.com/NixOS/nix/issues/599#issuecomment-153885553
LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"
export LOCALE_ARCHIVE
