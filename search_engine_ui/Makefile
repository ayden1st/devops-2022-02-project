# import config.

cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# dpl ?= deploy.env
# include $(dpl)
# export $(shell sed 's/=.*//' $(dpl))

.DEFAULT_GOAL := help
.PHONY: all

help:  ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

all: build_all push_all ## Build and Push all images.

build_ui: ## Build UI image.
	$(eval ID=$(shell docker build -q -t $(USER_NAME)/se_ui src/search_engine_ui))
	@echo ID = $(ID)
	$(eval VERSION=$(shell cat src/search_engine_ui/VERSION))
	@echo VERSION = $(VERSION)
	docker tag $(ID) $(USER_NAME)/se_ui:$(VERSION)
	docker tag $(ID) $(USER_NAME)/se_ui:latest

build_all: build_ui ## Build all

push_ui: ## Push UI image.
	$(eval ID=$(shell docker build -q -t $(USER_NAME)/se_ui src/search_engine_ui))
	docker push $(USER_NAME)/se_ui:$(VERSION)
	docker push $(USER_NAME)/se_ui:latest

push_all: push_ui ## Push all
