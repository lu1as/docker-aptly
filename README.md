# docker-aptly

docker image for [aptly](https://www.aptly.info/) debian repository management

Docker hub: [hub.docker.com/r/lu1as/aptly](https://hub.docker.com/r/lu1as/aptly)

## How to start

On start the entrypoint script will create a gpg key for package signing. You can skip this by setting `GPG_BOOTSTRAP` to `false`, e.g. if you want to use an existing gpg key.
Moreover a repository with packages located in `/packages` will be created and published. This step is also skippable by setting `REPO_BOOTSTRAP` to `false`. If `/packages` doesn't contain any packages, the script will fail.

|Environment variable|Type|Required|Default value|
|-|-|-|-|
|REPO_BOOTSTRAP|boolean|no|true|
|REPO_NAME|string|no|myrepo|
|REPO_DISTRIBUTION|string|no|debian|
|GPG_BOOTSTRAP|boolean|no|true|
|GPG_KEY_SIZE|int|no|4096|
|GPG_NAME|string|yes||
|GPG_EMAIL|string|yes||
|GPG_PASSPHRASE|string|yes||

The volume mounted at `/aptly` has to be owned by uid `1000` and gid `1000`. Otherwise the container user `aptly` won't have write permissions.

Example with automated repository creation:
```shell
docker run -v some-packages:/packages \
    -v aptly-data:/aptly \
    -v /dev/urandom:/dev/random \ # required with boot2docker for gpg key generation
    -e GPG_NAME=aptly-admin \
    -e GPG_EMAIL=test@test.com \
    -e GPG_PASSPHRASE=secret \
    -p 8080:8080 aptly
```

Example with manual repository creation:
```shell
docker run -it -v aptly-data:/aptly \
    -v /dev/urandom:/dev/random \ # required with boot2docker for gpg key generation
    -e REPO_BOOTSTRAP=false \
    -e GPG_BOOTSTRAP=false \
    -p 8080:8080 aptly bash
```

checkout https://www.aptly.info/doc/overview/ for following steps
