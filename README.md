# CST8918 - DevOps: Infrastructure as Code Final Project

## Project Overview

This is an Infrastructure as Code (IaC) project using Terraform, Azure AKS, and GitHub Actions. The project redeploys the Remix Weather Application from Week 3, using Terraform to create the required Azure resources, including Azure Kubernetes Service (AKS) clusters and managed Redis databases to support the Remix Weather Application.

The Azure configuration is stored in a Terraform backend in Azure Blob Storage. The Terraform code is organized into modules to manage resources. This project simulates a real-world scenario with multiple team members collaborating and managing multiple environments (dev, test, prod).

## Team Members

- **Zhiyuan Lu** ([lu000217](https://github.com/lu000217))
- **Zhe Zhang** ([Ethan05302](https://github.com/Ethan05302))

## Project Structure

```
├── terraform/                    # Terraform infrastructure code
│   ├── backend/                  # Azure Blob Storage backend module
│   ├── network/                  # Base network infrastructure module
│   ├── aks-clusters/            # AKS clusters module
│   ├── remix-weather-app/       # Remix Weather App module
│   ├── main.tf                  # Main Terraform configuration
│   ├── variables.tf             # Variable definitions
│   └── outputs.tf               # Output definitions
├── remix-weather-app/           # Remix Weather Application
├── .github/workflows/           # GitHub Actions workflows
└── README.md                    # Project documentation
```

## Infrastructure Components

### Network Infrastructure
- Resource Group: `cst8918-final-project-group-7`
- Virtual Network: IP address space `10.0.0.0/14`
- 4 Subnets:
  - prod: `10.0.0.0/16`
  - test: `10.1.0.0/16`
  - dev: `10.2.0.0/16`
  - admin: `10.3.0.0/16`

### AKS Clusters
- **Test Environment**: 1 node, Standard_DS2_v2 VM size, Kubernetes 1.32
- **Production Environment**: 1-3 nodes, Standard_DS2_v2 VM size, Kubernetes 1.32

### Application Infrastructure
- Azure Container Registry (ACR): `cst8918weatheracr`
- Test Environment Redis: `cst8918-test-redis` (in `cst8918-backend-rg`)
- Production Environment Redis: `cst8918-prod-redis` (in `cst8918-backend-rg`)
- Kubernetes namespace: `weather-app`
- Test domain: `test-weather.cst8918.com`
- Production domain: `weather.cst8918.com`

## GitHub Actions Workflows

### Automated Testing
- **terraform-static-analysis.yml**: Runs on push to any branch (fmt, validate, tfsec)
- **terraform-pr-checks.yml**: Runs on pull request to main branch (tflint, terraform plan)

### Deployment Process
- **docker-build-push.yml**: Builds and pushes Docker images to ACR when application code changes
- **app-deploy.yml**: Deploys Remix Weather Application to AKS clusters
  - Deploys to test environment on PR to main branch
  - Deploys to production environment on merge to main branch
- **terraform-apply.yml**: Applies Terraform changes on merge to main branch

## Setup Instructions

### Prerequisites
1. Azure subscription
2. GitHub repository access
3. Configured Azure service principal

### Environment Variables Setup
The following variables need to be configured in GitHub Secrets:
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `WEATHER_API_KEY`
- `ACR_USERNAME`
- `ACR_PASSWORD`

### Local Development
1. Clone the repository
2. Install Terraform
3. Configure Azure authentication
4. Run `terraform init` and `terraform apply`

## Technology Stack

- **Infrastructure as Code**: Terraform
- **Container Orchestration**: Azure Kubernetes Service (AKS)
- **Container Registry**: Azure Container Registry (ACR)
- **Caching**: Azure Cache for Redis
- **CI/CD**: GitHub Actions
- **Application Framework**: Remix
- **Programming Language**: TypeScript/JavaScript

