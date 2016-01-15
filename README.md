# docker-rwd

[![Travis CI](https://api.travis-ci.org/WikiWatershed/docker-rwd.svg "Build Status on Travis CI")](https://travis-ci.org/WikiWatershed/docker-rwd/)
[![Docker Repository on Quay.io](https://quay.io/repository/wikiwatershed/rwd/status "Docker Repository on Quay.io")](https://quay.io/repository/wikiwatershed/rwd)
[![Apache V2 License](http://img.shields.io/badge/license-Apache%20V2-blue.svg)](https://github.com/wikiwatershed/docker-rwd/blob/develop/LICENSE)

A Docker image for [Rapid Watershed Delineation](https://github.com/WikiWatershed/rapid-watershed-delineation).

##### Getting started
* Set the environment variables `RWD_REPO` (to your local copy of the RWD repo)
and `RWD_DATA` (to the RWD data, available via USB stick).
* Run `./scripts/build.sh` to build the container image.
* Run `./scripts/run.sh` to run the container, which will be given the name rwd.
This container is running a Flask API on port 5000. To test that it is running
properly, on Linux, go to `localhost:5000/rwd/-75.276639/39.892986.` On OS X,
find the ip of the default VM using `docker-machine ip default` and go to
`<default_vm_ip>:5000/rwd/-75.276639/39.892986.` After a few seconds, it should
return some GeoJSON.

##### Development workflow
* While running `./scripts/run.sh`, the server that is running will be
automatically updated with any changes you make to the source code in
[RWD](https://github.com/WikiWatershed/rapid-watershed-delineation). This
works because the container has mounted the contents of `RWD_REPO`.
* To test a change to `requirements.txt` or `src/api/requirements.txt` in RWD,
push a commit to a remote repository, update the RWD URL in `Dockerfile` with
the SHA of that commit, and then run `./scripts/build.sh`. This is cumbersome,
but should only need to be done infrequently. Alternatively, you can just add a
line to `Dockerfile` with `RUN pip install <package-name>` for the new package
you are adding to avoid invalidating the cache and having to re-install all the
dependencies. Of course, you should remove this line before merging.
After the PR to RWD is merged, update the SHA in the RWD URL in `Dockerfile`
and then submit a PR to this repo with that change.

##### Deployments
To create a release, run something along the lines of the following:

``` bash
$ git flow release start 0.1.0
$ vim CHANGELOG.md
$ vim Dockerfile
$ git commit -m "0.1.0"
$ git flow release publish 0.1.0
$ git flow release finish 0.1.0
$ git push --tags
```

When editing `Dockerfile`, change the RWD URL to point to the desired release
of RWD. (You may want to create a new release of
[RWD](https://github.com/WikiWatershed/rapid-watershed-delineation) first.)
