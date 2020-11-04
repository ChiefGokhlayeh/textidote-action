FROM debian:buster

LABEL name="textidote-action"
LABEL summary="TeXtidote LaTeX linter, spell- and grammar checker"
LABEL description="Part of GitHub Action textidote-action, used to lint, spell- and grammar-check LaTeX documents using TeXtidote."
LABEL version="v3.0"
LABEL url="https://github.com/ChiefGokhlayeh/textidote-action"
LABEL vcs-type="git"

ARG TEXTIDOTE_MAINTAINER=sylvainhalle
ARG TEXTIDOTE_REPO=textidote
ARG TEXTIDOTE_VERSION=v0.8.1

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    openjdk-11-jre \
    \
    && mkdir -p /usr/local/share/java/textidote \
    \
    && curl -fsSL -o /usr/local/share/java/textidote/textidote.jar "https://github.com/${TEXTIDOTE_MAINTAINER}/${TEXTIDOTE_REPO}/releases/download/${TEXTIDOTE_VERSION}/textidote.jar" \
    \
    && apt-get remove --purge -y curl \
    && apt-get autoremove -y \
    \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

COPY textidote /usr/local/bin/textidote
COPY entrypoint.sh /entrypoint.sh

ENV LANG=C.UTF-8

ENTRYPOINT ["/entrypoint.sh"]
