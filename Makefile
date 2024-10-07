SHELL := /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

## Host info
GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)

MODULE := k8s-crafts/ephemeral-containers-plugin

## Tool version. Bump for each release
VERSION ?= 0.1.0-dev

# Git Commit ID
GIT_COMMIT_NO := $(shell git rev-parse HEAD 2> /dev/null || true)
GIT_COMMIT_ID := $(if $(shell git status --porcelain --untracked-files=no),$(GIT_COMMIT_NO)-dirty,$(GIT_COMMIT_NO))

## Build flags
PLUGIN_LDFLAGS := -X $(MODULE)/pkg/version.version=v$(VERSION) -X $(MODULE)/pkg/version.gitCommitID=$(GIT_COMMIT_ID)

##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "Makefile for ephemeral-containers-plugin project\n\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: fmt
fmt: ## Run go fmt against source files.
	go fmt ./...

.PHONY: vet
vet: ## Run go vet agaist source files.
	go vet ./...

.PHONY: add-license
add-license: fmt vet go-license ## Add license header to source files.
	$(GO_LICENSE) --config license.yaml $(shell find ./ -name "*.go")

.PHONY: add-license
check-license: go-license ## Check license header to source files.
	$(GO_LICENSE) --verify --config license.yaml $(shell find ./ -name "*.go")
	
##@ Install tools

LOCAL_BIN ?= $(shell pwd)/bin
.PHONY: local-bin
local-bin: $(LOCAL_BIN) ## Location to install tools.
$(LOCAL_BIN):
	mkdir -p $(LOCAL_BIN)

GO_LICENSE ?= $(LOCAL_BIN)/go-license
PHONY: go-license
go-license: $(GO_LICENSE) ## Install go-license.
$(GO_LICENSE): local-bin
	test -s $(GO_LICENSE) || GOBIN=$(LOCAL_BIN) go install github.com/palantir/go-license@v1.39.0

##@ Build

BUILD_DIR ?= $(shell pwd)/build

.PHONY: build
build: ## Build ephemeral-containers-plugin binary (i.e. must have kubectl- prefix).
	mkdir -p $(BUILD_DIR)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build \
		-ldflags="$(PLUGIN_LDFLAGS)" \
		-o $(BUILD_DIR)/kubectl-ephemeral_containers \
		main.go

.PHONY: clean
clean: ## Clean built binaries
	- rm -rf $(BUILD_DIR)

# Default to $HOME/bin
INSTALL_DIR ?= $(HOME)/bin

.PHONY: install
install: ## Install the plugin to PATH. The binary must be built first (i.e. make build).
ifeq (,$(findstring $(INSTALL_DIR),$(PATH)))
	$(error $(INSTALL_DIR) is not on $$PATH)
else
	@if [ -s "$(INSTALL_DIR)/kubectl-ephemeral_containers" ]; then \
		echo "$(INSTALL_DIR)/kubectl-ephemeral_container exists. Please remove it with \"make uninstall\"."; \
		exit 1; \
	fi; \
	install -m 755 $(BUILD_DIR)/kubectl-ephemeral_containers $(INSTALL_DIR)/kubectl-ephemeral_containers
endif


.PHONY: uninstall
uninstall: ## Unistall the plugin from PATH.
ifeq (,$(findstring $(INSTALL_DIR),$(PATH)))
	$(error $(INSTALL_DIR) is not on $$PATH)
else
	- test -s $(INSTALL_DIR)/kubectl-ephemeral_containers && rm $(INSTALL_DIR)/kubectl-ephemeral_containers
endif
