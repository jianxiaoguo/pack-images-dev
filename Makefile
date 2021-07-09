# If DRYCC_REGISTRY is not set, try to populate it from legacy DEV_REGISTRY
STACK ?= 20
DEV_REGISTRY ?= docker.io

SHELLCHECK_PREFIX := docker run --rm -v ${CURDIR}:/workdir -w /workdir ${DEV_REGISTRY}/drycc/go-dev shellcheck
SHELL_SCRIPTS = $(shell find "buildpacks" -name '*.sh') $(shell find "rootfs" -name '*.sh') $(wildcard buildpacks/*/bin/*)

SHELL=/bin/bash -o pipefail

build:
	@docker build --pull -f Dockerfile.build --build-arg STACK=drycc-${STACK} --build-arg BASE_IMAGE=drycc/stack-images:${STACK}-build -t drycc/pack:${STACK}-build .
	@docker build --pull -f Dockerfile.run --build-arg STACK=drycc-${STACK} --build-arg BASE_IMAGE=drycc/stack-images:${STACK} -t drycc/pack:${STACK} .
	@pack builder create drycc/buildpacks:${STACK} --config builder-${STACK}.toml --pull-policy if-not-present

publish: build
	@docker push drycc/pack:${STACK}-build
	@docker push drycc/pack:${STACK}
	@docker push drycc/buildpacks:${STACK}

test-style:
	${SHELLCHECK_PREFIX} $(SHELL_SCRIPTS)
