FROM alpine:3.12

LABEL name="textidote-action"
LABEL summary="TeXtidote LaTeX linter, spell- and grammar checker"
LABEL description="Part of GitHub Action textidote-action, used to lint, spell- and grammar-check LaTeX documents using TeXtidote."
LABEL version="v1.0"
LABEL url="https://github.com/ChiefGokhlayeh/textidote-action"
LABEL vcs-type="git"

ARG TEXTIDOTE_MAINTAINER=sylvainhalle
ARG TEXTIDOTE_REPO=textidote
ARG TEXTIDOTE_VERSION=v0.8.1

RUN apk add --no-cache \
    bash \
    curl \
    openjdk11-jre \
    \
    && mkdir -p /usr/local/share/java/textidote \
    \
    && curl -fsSL -o /usr/local/share/java/textidote/textidote.jar "https://github.com/${TEXTIDOTE_MAINTAINER}/${TEXTIDOTE_REPO}/releases/download/${TEXTIDOTE_VERSION}/textidote.jar" \
    \
    && apk del curl

COPY textidote /usr/local/bin/textidote
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
