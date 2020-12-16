#!/usr/bin/env bash

# Source nix environment
nix_profile="$NIX_SYSTEM_PATH/etc/profile.d/nix.sh"
# shellcheck source=$NIX_SYSTEM_PATH/etc/profile.d/nix.sh
[ -e "${nix_profile}" ] && . "${nix_profile}"

# Propagate UTF8
# https://github.com/NixOS/nix/issues/599#issuecomment-153885553
LOCALE_ARCHIVE="$NIX_SYSTEM_PATH/lib/locale/locale-archive"
export LOCALE_ARCHIVE

PATH="$PATH:$NIX_SYSTEM_PATH/bin"
