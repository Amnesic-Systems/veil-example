app?=ssh-server
image_tag := $(app)
image_tar := $(app).tar
image_eif := $(app).eif

$(image_tar): $(app)/* Makefile
	@echo "Building $(image_tar)..."
	docker run \
		--quiet \
		--volume $(PWD)/$(app):/workspace \
		gcr.io/kaniko-project/executor:v1.9.2 \
		--reproducible \
		--tar-path $(image_tar) \
		--no-push \
		--verbosity warn \
		--destination $(image_tag) \
		--custom-platform linux/amd64 >/dev/null

$(image_eif): $(image_tar)
	@echo "Loading Docker image..."
	@docker load --quiet --input $(app)/$<
	@echo "Building $(image_eif)..."
	@nitro-cli build-enclave \
		--docker-uri $(image_tag) \
		--output-file $(app)/$(image_eif)

.PHONY: run
run: $(image_eif)
	@echo "Terminating any running enclave..."
	@nitro-cli terminate-enclave \
		--all
	@echo "Starting enclave..."
	@nitro-cli run-enclave \
		--enclave-name $(app) \
		--eif-path $(app)/$(image_eif) \
		--attach-console \
		--cpu-count 2 \
		--memory 3500

.PHONY: clean
clean:
	rm -f $(image_tar) $(image_eif)
