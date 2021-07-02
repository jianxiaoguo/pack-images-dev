# If DRYCC_REGISTRY is not set, try to populate it from legacy DEV_REGISTRY
DEV_REGISTRY ?= docker.io

SHELLCHECK_PREFIX := docker run --rm -v ${CURDIR}:/workdir -w /workdir ${DEV_REGISTRY}/drycc/go-dev shellcheck
SHELL_SCRIPTS = $(shell find "buildpacks" -name '*.sh') $(shell find "rootfs" -name '*.sh') $(wildcard buildpacks/*/bin/*)

SHELL=/bin/bash -o pipefail

build:
	@docker build --pull -f Dockerfile.build --build-arg STACK=drycc-20 --build-arg BASE_IMAGE=registry.uucin.com/lijianguo/stack-images:20-build -t registry.uucin.com/lijianguo/pack:20-build .
	@docker build --pull -f Dockerfile.run --build-arg STACK=drycc-20 --build-arg BASE_IMAGE=registry.uucin.com/lijianguo/stack-images:20 -t registry.uucin.com/lijianguo/pack:20 .
	@pack builder create registry.uucin.com/lijianguo/buildpacks:20 --config builder-20.toml --pull-policy if-not-present

publish: build
	@docker push registry.uucin.com/lijianguo/pack:20-build
	@docker push registry.uucin.com/lijianguo/pack:20
	@docker push registry.uucin.com/lijianguo/buildpacks:20

test-style:
	${SHELLCHECK_PREFIX} $(SHELL_SCRIPTS)
