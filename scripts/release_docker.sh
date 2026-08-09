#!/bin/bash

VERSION=$(ruby -e "require_relative 'lib/mdl/version.rb'; puts MarkdownLint::VERSION")
echo "Create docker image for $VERSION (y/n) ?"
read ans
if [ "$ans" == 'y' ]; then
    cd tools/docker
    podman build --no-cache -t markdownlint/markdownlint:latest \
        -t markdownlint/markdownlint:${VERSION?} . && \
    podman push markdownlint/markdownlint:latest && \
    podman push markdownlint/markdownlint:${VERSION?}
else
    echo "Bailing out..."
fi
