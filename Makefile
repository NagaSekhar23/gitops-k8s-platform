.PHONY: all infra apps deploy clean test

all: infra apps deploy

infra:
	@echo "🚀 Provisioning EKS cluster..."
	cd infra/terraform && terraform init && terraform apply -auto-approve

apps:
	@echo "📦 Deploying platform charts..."
	helm upgrade --install platform ./charts/platform -n platform --create-namespace
	helm upgrade --install monitoring ./charts/monitoring -n monitoring --create-namespace

deploy:
	@echo "🔄 GitOps sync via Kustomize..."
	kustomize build environments/dev/base | kubectl apply -f -

argocd-sync:
	@echo "⚡ ArgoCD sync all apps"
	kubectl argo app sync platform-webapp
	kubectl argo app sync platform-api

clean:
	@echo "🧹 Cluster cleanup..."
	helm uninstall platform monitoring
	kustomize build environments/dev/base | kubectl delete -f -

test:
	@echo "🧪 Validate manifests..."
	helm lint apps/*/
	kustomize build environments/dev/base | kubeval -
