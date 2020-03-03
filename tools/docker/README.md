# Docker container for markdownlint

## Using the docker image

To check a single file:

    docker run --rm -v ${PWD}:/data markdownlint/markdownlint myfile.md

Or, to check all files in a directory:

    docker run --rm -v ${PWD}:/data markdownlint/markdownlint .

## Building from a docker file

The following will tag and upload a new release. Replace X.Y.Z as appropriate.

    docker build -t markdownlint/markdownlint:latest -t markdownlint/markdownlint:X.Y.Z .
    docker push markdownlint/markdownlint:latest
    docker push markdownlint/markdownling:X.Y.Z
