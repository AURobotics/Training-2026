FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && apt-get install -y curl git cargo

USER vscode

RUN cargo install --locked typst-cli