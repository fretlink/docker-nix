## Nix package manager Docker Image

[![Build Status](https://travis-ci.com/fretlink/docker-nix.svg?branch=master)](https://travis-ci.com/fretlink/docker-nix) [![Docker Hub](https://img.shields.io/badge/docker-fretlink%2Fnix-blue.svg?style=flat)](https://registry.hub.docker.com/u/fretlink/nix/)

This image contains an installation of the [Nix package manager](https://nixos.org/nix/) installed as a single-user `nixuser`.

This is based on the unpublished Dockerfile previously available at https://github.com/romcheck/nix.

Use this build to create your own customized images as follows:

    FROM fretlink/nix

    RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    RUN nix-channel --update

    RUN nix-build -A pythonFull '<nixpkgs>'
