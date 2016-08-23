# Docker container for markdownlint

## Using the docker image

To check a single file:

    docker run --rm -v ${PWD}:/data mivok/markdownlint myfile.md

Or, to check all files in a directory:

    docker run --rm -v ${PWD}:/data mivok/markdownlint .

## Building from a docker file

The following will tag and upload a new release. Replace X.Y.Z as appropriate.

    docker build -t mivok/markdownlint:latest -t mivok/markdownlint:X.Y.Z .
    docker push mivok/markdownlint:latest
    docker push mivok/markdownling:X.Y.Z
