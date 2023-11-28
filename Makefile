.PHONY: prepare
prepare: build-image

.PHONY: build-image
build-image:
	docker build -t github.com/safinfin/devcontainer-python-tmpl:latest -f docker/Dockerfile .
