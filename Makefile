.PHONY: prepare
prepare: build-image

.PHONY: build-image
build-image:
	docker build -t repo-name:latest -f docker/Dockerfile .
