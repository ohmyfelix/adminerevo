DOCKER_IMAGE=dockette/adminerevo
DOCKER_PLATFORM=linux/amd64
DOCKER_TEST_PORT=8080

.PHONY: build
build: docker-build

.PHONY: test
test: docker-test

.PHONY: run
run: docker-run

.PHONY: docker-build
docker-build:
	docker buildx \
		build \
		--platform ${DOCKER_PLATFORM} \
		--pull \
		--load \
		-t ${DOCKER_IMAGE} \
		adminerevo

.PHONY: docker-test
docker-test: docker-build
	@set -e; \
	container=$$(docker run --rm -d \
		--platform ${DOCKER_PLATFORM} \
		-p ${DOCKER_TEST_PORT}:8080 \
		${DOCKER_IMAGE}); \
	trap 'docker stop $$container >/dev/null' EXIT; \
	sleep 3; \
	curl -fsS http://localhost:${DOCKER_TEST_PORT}/ >/dev/null

.PHONY: docker-run
docker-run:
	docker run \
		-it \
		--rm \
		--platform ${DOCKER_PLATFORM} \
		-p 8080:8080 \
		--name adminer \
		${DOCKER_IMAGE}
