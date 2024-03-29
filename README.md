[![GPL 3 License](https://img.shields.io/github/license/yuri-becker/seafile-mount?style=for-the-badge&logo=gnu&logoColor=white&color=%23A42E2B )](https://github.com/yuri-becker/seafile-mount/blob/latest/LICENSE.md)
[![Docker](https://img.shields.io/docker/pulls/yuribecker/seafile-mount?style=for-the-badge&logo=docker&logoColor=white&color=%232496ED
)](https://hub.docker.com/r/yuribecker/seafile-mount)
[![GitHub](https://img.shields.io/github/stars/yuri-becker/seafile-mount?style=for-the-badge&logo=github&logoColor=white&color=%23181717)](https://github.com/yuri-becker/seafile-mount)

<br />
<div align="center">

  <h1 align="center"><strong>seafile-mount</strong></h1>

  <p align="center">
    Mount your <a href="https://www.seafile.com/en/home/">Seafile</a> libraries, but containerized.
  </p>
</div>

## About

This docker image mounts a [Seafile](https://www.seafile.com/en/home/) user's library using the [seadrive](https://help.seafile.com/drive_client/drive_client_for_linux/) client, which streams a filesystem instead of syncing.

Using Seadrive containerized has several advantages (probably – in my case, it was just an infrastructural requirement).

Image supports x86_64 and arm64 because that's what Seadrive is available for. Albeit, the arm64 Debian repository for Seadrive didn't receive the latest patches, but still works.


## Drawbacks

Your **host** system needs to have [Fuse](https://github.com/libfuse/libfuse) installed and the container needs to be run with `--privileged`.

## Running it

* Configure using [environment variables](#environment-variables).
* Give extended privileges ([Engine](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities), [Compose](https://docs.docker.com/compose/compose-file/05-services/#privileged))
* [Bind mount](https://docs.docker.com/storage/bind-mounts/#use-a-bind-mount-with-compose) `/seafile` with type `bind` and bind-propagation `rshared`.
* Image is just called `seafile-mount`

### Example

#### Command line

```sh
docker run --privileged \
--env-file ./.env \
--mount type=bind,source=/home/yuri/seafile-mount,target=/seafile,bind-propagation=rshared \
-it seafile-mount
```

#### docker-compose.yml

```yaml
version: "3"
services:
  seadrive:
    container_name: seadrive
    image: yuribecker/seafile-mount:latest
    environment:
      - SEAFILE_MOUNT_SERVER=https://seadrive.example.org
      - SEAFILE_MOUNT_USERNAME=username@example.org
      - SEAFILE_MOUNT_TOKEN=TOKEN
    privileged: true
    volumes:
      - type: bind
        bind:
          propagation: rshared
        source: /home/yuri/seafile-mount
        target: /seafile

```



## Environment Variables

| Name                               | Description                                                                                                                                                       | Default              |
|------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------|
| SEAFILE_MOUNT_SERVER               | URL of your server (including https://)                                                                                                                           | *required*           |
| SEAFILE_MOUNT_USERNAME             | Username (email) of the user                                                                                                                                      | *required*           |
| SEAFILE_MOUNT_TOKEN                | Token for the user, see [Acquiring a Token](#acquiring-a-token)                                                                                                   | required             |
| SEAFILE_MOUNT_IS_PRO               | Is server Professional Edition? (`true`/`false`)                                                                                                                  | false                |
| SEAFILE_MOUNT_CLIENT_NAME          | Name for how this client should show up in Seafile's admin panel                                                                                                  | Seafile Docker Mount |
| SEAFILE_MOUNT_CACHE_SIZE_LIMIT     | Size limit for the cache                                                                                                                                          | 10GB                 |
| SEAFILE_MOUNT_CLEAN_CACHE_INTERVAL | Interval for cache cleaning in minutes                                                                                                                            | 10                   |
| SEAFILE_MOUNT_ALLOW_OTHER          | Set to yes to mount with `allow_other` instead of `allow_root` ([see FUSE mount options](https://www.systutorials.com/docs/linux/man/8-mount.fuse/)) (`yes`/`no`) | *optional*           |

See
the [official documentation](https://help.seafile.com/drive_client/drive_client_for_linux/#running-seadrive-without-gui)
for more info about these options.<br/>
<sub>"Info" in this case means there isn't much info in the official documentation anyway.</sub>

### Acquiring a Token

As shown in the [official documentation](https://help.seafile.com/drive_client/drive_client_for_linux/#running-seadrive-without-gui), request a token from your Seafile instance's API.

```sh
curl --url https://YOUR_SEAFILE_INSTANCE/api2/auth-token/ \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data-urlencode "username=EMAIL" \
  --data-urlencode "password=PASSWORD"
```

Note that it doesn't work with a Token extracted from a browser session.

