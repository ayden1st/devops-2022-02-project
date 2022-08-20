# import config.

cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.DEFAULT_GOAL := help
.PHONY: all

help:  ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

install_app: ## Install yc, kubectl and helm
	wget https://hashicorp-releases.yandexcloud.net/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip
	curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
	curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
	kubectl version --client
	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add gitlab https://charts.gitlab.io
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

install_yc_mk8s: ## Install Yandex Cloud Managed Kubernetes
	@cd terraform && \
	terraform init -input=false && \
	terraform plan -out=tfplan -input=false && \
	terraform apply -input=false tfplan && \
	rm tfplan && \
	terraform output --raw kubeconfig > ~/.kube/config

install_ingress: ## Install or upgrade ingress-nginx
	helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.1.4

install_monitoring: ## Install or upgrade Prometheus monitoring
	helm upgrade --install prom prometheus-community/kube-prometheus-stack \
	--namespace monitoring --create-namespace \
	-f Charts/monitoring/values.yaml \
	--set alertmanager.config.global.slack_api_url=$(SLACK_URL) \
	--set grafana.adminPassword=$(GRAFANA_PASS)

install_elastic: ## Install or upgrade Elasticsearch and Kibana
	helm upgrade --install elastic bitnami/elasticsearch \
	--namespace logging --create-namespace \
	-f Charts/logging/elasticsearch-values.yaml

install_fluentd: ## Install or upgrade Fluentd
	helm upgrade --install fluentd bitnami/fluentd \
	--namespace logging --create-namespace \
	-f Charts/logging/fluentd-values.yaml

install_loki: ## Install or upgrade Loki stack
	helm upgrade --install loki grafana/loki-stack \
	--namespace logging --create-namespace \
	-f Charts/logging/loki-stack-values.yaml

install_logging: install_loki ## Install or upgrade logging

install_infra_all: install_ingress install_monitoring install_logging ## Install or upgrade Ingress, Monitoring, Logging

install_runner: ## Install or upgrade GitLab runner in K8S
	helm upgrade --install --namespace default gitlab-runner gitlab/gitlab-runner \
	-f Charts/runner/values.yaml \
	--set gitlabUrl=$(RUNNER_URL) \
	--set runnerRegistrationToken=$(RUNNER_TOKEN)
	kubectl apply -f Charts/runner/gitlab-service-account.yaml
	kubectl -n kube-system get secrets -o json | \
    jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | \
    base64 --decode > token

destroy_yc_mk8s: ## Destroy Yandex Cloud Managed Kubernetes
	@cd terraform && \
	terraform init -input=false && \
	terraform plan -out=tfplan -destroy && \
	terraform apply tfplan && \
	rm tfplan
