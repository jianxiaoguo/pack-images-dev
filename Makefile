# If DRYCC_REGISTRY is not set, try to populate it from legacy DEV_REGISTRY
STACK ?= 20
DEV_REGISTRY ?= docker.io

SHELLCHECK_PREFIX := docker run --rm -v ${CURDIR}:/workdir -w /workdir ${DEV_REGISTRY}/drycc/go-dev shellcheck
SHELL_SCRIPTS = $(shell find "buildpacks" -name '*.sh') $(shell find "rootfs" -name '*.sh') $(wildcard buildpacks/*/bin/*)

SHELL=/bin/bash -o pipefail

build:
	@docker build --pull -f Dockerfile.build --build-arg STACK=drycc-${STACK} --build-arg BASE_IMAGE=registry.uucin.com/lijianguo/stack-images:${STACK}-build -t registry.uucin.com/lijianguo/pack:${STACK}-build .
	@docker build --pull -f Dockerfile.run --build-arg STACK=drycc-${STACK} --build-arg BASE_IMAGE=registry.uucin.com/lijianguo/stack-images:${STACK} -t registry.uucin.com/lijianguo/pack:${STACK} .
	@pack builder create registry.uucin.com/lijianguo/buildpacks:${STACK} --config builder-${STACK}.toml --pull-policy if-not-present

publish: build
	@docker push registry.uucin.com/lijianguo/pack:${STACK}-build
	@docker push registry.uucin.com/lijianguo/pack:${STACK}
	@docker push registry.uucin.com/lijianguo/buildpacks:${STACK}

test-style:
	${SHELLCHECK_PREFIX} $(SHELL_SCRIPTS)
