# Docker container for markdownlint

## Using the docker image

To check a single file:

```shell
docker run --rm -v ${PWD}:/data markdownlint/markdownlint myfile.md
```

Or, to check all files in a directory:

```shell
docker run --rm -v ${PWD}:/data markdownlint/markdownlint .
```

## Building from a docker file

The following will tag and upload a new release. Replace X.Y.Z as appropriate.

```shell
VERSION=X.Y.Z
podman build -t markdownlint/markdownlint:latest \
    -t markdownlint/markdownlint:${VERSION?} .
podman push markdownlint/markdownlint:latest
podman push markdownlint/markdownling:${VERSION?}
```
