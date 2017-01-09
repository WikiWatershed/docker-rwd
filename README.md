# docker-rwd

[![Travis CI](https://api.travis-ci.org/WikiWatershed/docker-rwd.svg "Build Status on Travis CI")](https://travis-ci.org/WikiWatershed/docker-rwd/)
[![Docker Repository on Quay.io](https://quay.io/repository/wikiwatershed/rwd/status "Docker Repository on Quay.io")](https://quay.io/repository/wikiwatershed/rwd)
[![Apache V2 License](http://img.shields.io/badge/license-Apache%20V2-blue.svg)](https://github.com/wikiwatershed/docker-rwd/blob/develop/LICENSE)

A Docker image for [Rapid Watershed Delineation](https://github.com/WikiWatershed/rapid-watershed-delineation).

### Getting started
* Define environment variables (see below)
* Run `./scripts/update.sh`
* Run `./scripts/run.sh`

#### Linux
* Run `curl http://localhost:5000/rwd/-75.276639/39.892986`

#### OS X
* Find the IP of the default VM using `docker-machine ip default`
* Run `curl http://<default_vm_ip>:5000/rwd/-75.276639/39.892986`

### Environment Variables

| Name       | Description                                  | Example                             |
| ---------- | -------------------------------------------- | ----------------------------------- |
| `RWD_REPO` | Path to `rapid-watershed-delination` | `/var/projects/rapid-watershed-delineation` |
| `RWD_DATA` | Path to RWD data                     | `/media/passport/rwd-nhd`                   |

### RWD Data

Folder structure:

```
> tree -L 2 /media/passport/rwd-nhd/
|-- drb
|   |-- Main_Watershed
|   `-- Subwatershed_ALL
`-- nhd
    |-- Main_Watershed
    |-- Subwatershed_ALL
```

### Deployments

``` bash
$ git flow release start 0.1.0
$ vim CHANGELOG.md
$ vim Dockerfile
$ git commit -m "0.1.0"
$ git flow release publish 0.1.0
$ git flow release finish 0.1.0
$ git push --tags
```
