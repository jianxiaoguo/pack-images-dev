# Drycc Pack Base Images

[![CircleCI](https://circleci.com/gh/drycc/pack-images.svg?style=svg)](https://circleci.com/gh/heroku/pack-images)

This repository is responsible for building and publishing images that builds
with [Cloud Native Buildpacks'](https://buildpacks.io)
[`pack`](https://github.com/buildpacks/pack) command.

* [drycc/pack:20](https://hub.docker.com/r/heroku/pack/tags/) - A CNB
  compatible run image based on drycc:20
* [drycc/pack:20-build](https://hub.docker.com/r/heroku/pack/tags/) - A CNB
  compatible build image based on drycc:20-build

## Usage

`pack build myapp --builder drycc/buildpacks:18`
