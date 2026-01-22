# 🚀 GitOps-Driven Kubernetes Platform (Production-Grade)

A **production-ready GitOps Kubernetes platform** built on **AWS EKS** using **Terraform, Istio, Argo CD, Helm, Prometheus, and Grafana**.  
The platform deploys **4 microservices** with **service mesh**, **GitOps delivery**, **CI/CD pipelines**, **zero-downtime deployments**, and **golden signals observability**.

This project demonstrates **real-world platform engineering**, **SRE practices**, and **cloud-native architecture**.

---

## ✨ Key Highlights

- 🔁 **GitOps-first delivery** using Argo CD (App-of-Apps pattern)
- ☁️ **Infrastructure as Code** with Terraform (VPC + EKS)
- 🕸️ **Service Mesh** with Istio (canary + blue/green)
- 📊 **Golden Signals Monitoring** (latency, traffic, errors, saturation)
- 🧪 **Chaos Engineering dashboards** for fault visibility
- 🚀 **CI/CD pipeline** using GitHub Actions → ECR → Argo CD
- 💸 **AWS Free Tier friendly** (~$6/month)

---

## 🎯 Features

### ✅ Infrastructure as Code
- Terraform-managed **VPC** (private subnets, NAT Gateway)
- **EKS 1.30** cluster with **2× t3.micro nodes**
- Fully reproducible and version-controlled

### ✅ GitOps Delivery
- **Argo CD 6.7.5**
- App-of-Apps pattern
- Auto-sync, self-healing, pruning enabled

### ✅ Service Mesh
- **Istio 1.23**
- Automatic sidecar injection
- Canary deployments (90/10)
- Blue-green traffic shifting via `VirtualService`

### ✅ Microservices
- 4 production services:
  - `frontend`
  - `cart`
  - `payment`
  - `order`
- Horizontal Pod Autoscaler (HPA)
- mTLS enabled via Istio

### ✅ Observability
- **Prometheus + Grafana**
- Golden signals dashboards:
  - Latency
  - Traffic
  - Errors
  - Saturation

### ✅ Chaos Engineering
- Fault injection visibility
- Error rate & latency impact dashboards

### ✅ CI/CD
- GitHub Actions
- Docker image build & push to ECR
- Argo CD auto-sync on Git changes

---
gitops-k8s-platform/  [https://github.com/NagaSekhar23/gitops-k8s-platform](https://github.com/NagaSekhar23/gitops-k8s-platform)
├── infra/
│   └── terraform/      # ✅ EKS cluster (main.tf here)
├── environments/
│   └── prod/           # Env-specific overrides (values.yaml)
├── charts/
│   └── argo-apps/      # Helm charts for ArgoCD apps
├── .github/
│   └── workflows/      # CI/CD pipelines
└── .git/               # Git internals

## 🏗️ High-Level Architecture

GitHub Repo ──🚀──> Argo CD ──📦──> Istio Gateway ──🌐──> Microservices
↓ ↓
Terraform ──💻──> EKS Prometheus ──📊──> Grafana
(VPC + Nodes) (Golden Signals + Chaos)
---

## 🚀 Quick Start (Production Deployment)

### 📌 Prerequisites

```bash
aws configure set region us-west-2
terraform --version   # >= 1.9.5
kubectl version       # >= 1.30
helm version          # >= 3.15
1️⃣ Deploy Infrastructure (≈15 minutes)
cd infrastructure/vpc
terraform apply    # Creates VPC, subnets, NAT Gateway

cd ../eks
terraform apply    # Creates EKS cluster (33 resources)

aws eks update-kubeconfig \
  --name gitops-platform-eks \
  --region us-west-2

2️⃣ Verify Cluster
kubectl get nodes
kubectl get pods -n kube-system


Expected:

2 nodes in Ready state

CoreDNS & VPC CNI running

3️⃣ Deploy GitOps Platform (≈5 minutes)
kubectl apply -k k8s-manifests/argocd-apps/


Access Argo CD:

kubectl port-forward svc/argocd-server -n argocd 8080:443


Retrieve admin password:

kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath='{.data.password}' | base64 -d


👉 Argo CD UI: http://localhost:8080

4️⃣ Access Production Services
Service	URL
Frontend	http://<ISTIO-GATEWAY-IP>
Grafana	http://localhost:3000
Argo CD	http://localhost:8080

Grafana credentials:

username: admin
password: prom-operator

📁 Repository Structure
gitops-k8s-platform/
├── infrastructure/
│   ├── vpc/              # Terraform VPC (NAT, private subnets)
│   └── eks/              # EKS cluster + node groups
├── k8s-manifests/
│   ├── argocd-apps/      # Root App-of-Apps
│   ├── istio/            # Istio base + ingress gateway
│   ├── services/         # frontend/cart/payment/order
│   └── monitoring/       # Prometheus + Grafana
├── charts/               # Custom Helm charts
├── docs/                 # Architecture & diagrams
└── .github/workflows/    # CI/CD pipelines

🔧 Technology Stack
Layer	Technology	Version
IaC	Terraform	1.9.5
Kubernetes	EKS	1.30
Service Mesh	Istio	1.23
GitOps	Argo CD	6.7.5
Monitoring	Prometheus	2.53
Visualization	Grafana	11.1
CI/CD	GitHub Actions	v4
📊 Golden Signals Monitoring

Grafana dashboards include:

Istio Mesh Traffic / Errors / Latency

Node CPU & Memory (85% threshold for t3.micro)

Pod HPA scale events

Chaos fault injection impact

🔄 CI/CD Pipeline

GitHub Actions → ECR → Argo CD

name: GitOps CD
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          argocd app sync platform-root \
            --prune \
            --force


Git push triggers image build

Argo CD reconciles desired state automatically

Zero-downtime rollout via Istio

🧪 Production Verification
kubectl get nodes

ip-10-0-1-XXX   Ready   v1.30.4-eksbuild.2
ip-10-0-2-YYY   Ready   v1.30.4-eksbuild.2

kubectl get pods -A | grep Running

argocd-server                Running
istio-ingressgateway         Running
prometheus-kube-prometheus   Running
frontend-xxxxx               Running  2/2   # Istio sidecar ✓

💰 Cost Analysis (Monthly)
Resource	Quantity	Cost
EC2 t3.micro	2 nodes	$0 (Free Tier)
NAT Gateway	1	$4.60
EBS Storage	20 GB	$2.00
Total		$6.60
🧠 What This Project Demonstrates

Real-world Platform Engineering

GitOps at scale

Kubernetes service mesh patterns

SRE observability practices

Cost-optimized AWS architecture

📜 License

MIT License

