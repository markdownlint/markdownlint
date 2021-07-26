# Docker container for markdownlint

## Using the docker image

To check a single file:

```shell
docker run --rm -i markdownlint/markdownlint < myfile.md
```

Or, to check all files in a directory:

```shell
docker run --rm -v ${PWD}:/data markdownlint/markdownlint mdl .
```

### GitLab CI

To use markdownlint in your GitLab CI:

```yaml
markdownlint:
  stage: lint
  image: markdownlint/markdownlint
  script: mdl README.md
```

## Building from a docker file

The following will tag and upload a new release. Replace X.Y.Z as appropriate.

```shell
docker build -t markdownlint/markdownlint:latest \
    -t markdownlint/markdownlint:X.Y.Z .
docker push markdownlint/markdownlint:latest
docker push markdownlint/markdownling:X.Y.Z
```
