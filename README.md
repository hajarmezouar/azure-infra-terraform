# Azure Infrastructure with Terraform

## Overview

This project provisions Azure infrastructure using **Terraform** following Infrastructure as Code (IaC) best practices.

The infrastructure is organized into reusable Terraform modules and deployed to Microsoft Azure. A remote Terraform backend stored in Azure Blob Storage is used to manage the Terraform state securely and support collaboration.

This project is the Terraform continuation of the previous **Azure Infrastructure CLI** project, where the same infrastructure was deployed manually using Azure CLI. The goal of this project is to replace manual resource provisioning with reusable, declarative Terraform code.

---

# Technologies

- Terraform
- Microsoft Azure
- Azure CLI
- Bash
- Git & GitHub

---

# Project Architecture

The project provisions the following Azure resources:

- Azure Storage Account
- Blob Containers
- Linux App Service
- Linux Function App
- Azure Container Instance (NGINX)
- Azure Remote Backend (Blob Storage)

---

# Project Structure

```text
azure-infra-terraform/
│
├── scripts/
│   ├── config.sh
│   ├── backend.sh
│   └── terraform-init.sh
│
├── terraform/
│   ├── backend.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   ├── outputs.tf
│   └── modules/
│       ├── storage/
│       ├── app-service/
│       ├── function-app/
│       └── container/
│
└── README.md
```

---

# Terraform Modules

## Storage

Creates:

- Azure Storage Account
- Blob Container `api-logs`
- Blob Container `api-config`

---

## App Service

Creates:

- Linux App Service
- Python 3.11 runtime
- HTTPS Only
- TLS 1.2

Uses the shared App Service Plan provided by the trainer.

---

## Function App

Creates:

- Dedicated Storage Account
- Linux Function App
- Python 3.11 runtime

---

## Container

Creates:

- Azure Container Instance
- Public IP
- Public DNS Name
- NGINX container

---

# Remote Backend

Terraform state is stored remotely in Azure Blob Storage.

Backend resources:

| Resource | Name |
|----------|------|
| Resource Group | rg-tfstate-hajar-mezouar |
| Storage Account | ststatehajarmezouar |
| Blob Container | tfstate |
| State File | hajar-mezouar.terraform.tfstate |

The backend is initialized automatically using a Bash script.

---

# Automation Scripts

## config.sh

Contains the common project configuration.

Example:

```bash
OWNER="hajar-mezouar"

LOCATION="francecentral"

RESOURCE_GROUP="hmezouarRG"

BACKEND_RG="rg-tfstate-${OWNER}"
BACKEND_STORAGE="ststate${OWNER//-/}"
BACKEND_CONTAINER="tfstate"
BACKEND_KEY="${OWNER}.terraform.tfstate"
```

---

## backend.sh

Automatically creates:

- Backend Resource Group
- Storage Account
- Blob Container

---

## terraform-init.sh

Initializes Terraform with the Azure backend.

---

# Usage

## Login

```bash
az login
```

Select the subscription

```bash
az account set --subscription "Azure for Students"
```

Verify

```bash
az account show
```

---

## Create the backend

```bash
./scripts/backend.sh
```

---

## Initialize Terraform

```bash
./scripts/terraform-init.sh
```

---

## Format

```bash
terraform fmt
```

---

## Validate

```bash
terraform validate
```

---

## Plan

```bash
terraform plan
```

---

## Deploy

```bash
terraform apply
```

---

## Destroy

```bash
terraform destroy
```

---

# Terraform Concepts Practiced

During this project I practiced:

- Infrastructure as Code (IaC)
- Terraform Providers
- Terraform Modules
- Variables
- Outputs
- Data Sources
- Resource Dependencies
- Remote State
- AzureRM Backend
- State Migration
- Azure Blob Storage
- Azure Resource Providers
- Bash Automation

---

# Challenges Encountered

### Azure Resource Provider

The `Microsoft.Storage` resource provider was not registered on the Azure subscription.

Resolution:

```bash
az provider register --namespace Microsoft.Storage
```

---

### Remote Backend

Migrated from a local Terraform state to an Azure Blob Storage backend.

---

### Bash Automation

Automated backend creation and Terraform initialization using reusable Bash scripts.

---

# Skills Demonstrated

- Infrastructure as Code
- Azure Administration
- Terraform Module Design
- Azure Storage
- Azure App Services
- Azure Functions
- Azure Container Instances
- Bash Scripting
- Git Version Control
- Cloud Infrastructure Automation

---

# Future Improvements

- GitHub Actions CI/CD
- Terraform validation in CI
- Terraform Plan and Apply automation
- OpenID Connect (OIDC) authentication
- Separate Development and Production environments
- Terraform Workspaces
- Remote State Locking