# Azure Infrastructure with Terraform

## Overview

This project provisions a complete Microsoft Azure infrastructure using **Terraform**, following Infrastructure as Code (IaC) best practices.

The infrastructure is organized into reusable Terraform modules and deployed on an **Azure for Students** subscription. A **remote Terraform backend** stored in Azure Blob Storage is used to securely manage the Terraform state and enable consistent deployments.

Infrastructure provisioning is automated through reusable Bash scripts, while deployment is integrated with **GitHub Actions** using **OpenID Connect (OIDC)** authentication. This approach removes the need to store Azure client secrets by allowing GitHub Actions to authenticate securely with Azure through a federated identity.

This project is the Terraform continuation of the previous **Azure Infrastructure CLI** project, where the same infrastructure was provisioned manually using Azure CLI. The objective was to replace imperative provisioning with reusable, modular and automated Infrastructure as Code.

---

# Technologies

- Terraform
- Microsoft Azure
- Azure Resource Manager (AzureRM)
- Azure Storage
- Azure App Service
- Azure Functions
- Azure Container Instance
- Azure Networking
- Azure CLI
- Bash
- Git & GitHub
- GitHub Actions
- OpenID Connect (OIDC)

---

# Project Architecture

The infrastructure provisions the following Azure resources:

- Azure Resource Group
- Azure App Service Plan (Linux B1)
- Azure Linux Web App (Python 3.11)
- Azure Linux Function App (Python 3.11)
- Azure Storage Account
- Azure Storage Account for Function App
- Azure Blob Containers (`api-logs`, `api-config`)
- Azure Container Instance (NGINX)
- Azure Virtual Network
- Frontend Subnet
- Backend Subnet
- Network Security Group
- Network Security Group Association
- Remote Terraform Backend (Azure Blob Storage)

---

# Architecture Overview

```text
                          Terraform
                              │
                              ▼
                   Azure Resource Group
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
 Storage Account      App Service Plan      Container Instance
        │                     │
        │             ┌───────┴────────┐
        ▼             ▼                ▼
 Blob Containers   Web App       Function App
                                         │
                                         ▼
                              Function Storage Account

                     ▼
              Virtual Network
            ├── Frontend Subnet
            └── Backend Subnet
                     │
                     ▼
          Network Security Group
```

---

# Project Structure

```text
azure-infra-terraform/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── scripts/
│   ├── config.sh
│   ├── backend.sh
│   └── terraform-init.sh
│   └── github-oidc.sh
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
│       ├── container/
│       └── network/
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

- Azure App Service Plan (Linux B1)
- Linux Web App
- Python 3.11 Runtime
- HTTPS Only
- TLS 1.2

---

## Function App

Creates:

- Dedicated Storage Account
- Linux Function App
- Python 3.11 Runtime

---

## Container

Creates:

- Azure Container Instance
- Public IP Address
- Public DNS Name
- NGINX Container

---

## Network

Creates:

- Azure Virtual Network
- Frontend Subnet
- Backend Subnet
- Network Security Group
- NSG Association

---

# Remote Backend

Terraform state is stored remotely in Azure Blob Storage.

Backend resources:

| Resource | Name |
|----------|------|
| Resource Group | `rg-tfstate-hajar-mezouar` |
| Storage Account | `ststatehajarmezouar` |
| Blob Container | `tfstate` |
| State File | `hajar-mezouar.terraform.tfstate` |

The backend is created automatically using a Bash script.

---

# Automation Scripts

## config.sh

Stores the common project configuration used by all automation scripts, including the Azure region, Resource Group, backend configuration and GitHub repository information.

---

## backend.sh

Creates the Azure Storage backend used to store the Terraform state remotely.

Resources created:

- Backend Resource Group
- Storage Account
- Blob Container

---

## terraform-init.sh

Initializes Terraform using the Azure Blob Storage remote backend.

---

## github-oidc.sh

Automates the configuration of Azure OpenID Connect (OIDC) authentication for GitHub Actions.

The script:

- Creates (or reuses) an Azure App Registration
- Creates (or reuses) a Service Principal
- Creates the Federated Credential
- Displays the values required for the GitHub Environment Secrets

---

# GitHub Actions CI/CD

Infrastructure deployment is automated using **GitHub Actions**.

The workflow is located in:

```text
.github/workflows/terraform.yml
```

The pipeline performs:

- Terraform formatting check
- Terraform validation
- Terraform plan on Pull Requests
- Terraform apply on pushes to the `main` branch

GitHub Actions authenticates to Azure using **OpenID Connect (OIDC)**, eliminating the need to store Azure client secrets.

Required GitHub Environment Secrets:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

--- 

# Usage

## Login

```bash
az login
```

Select the subscription:

```bash
az account set --subscription "Azure for Students"
```

Verify:

```bash
az account show
```

---

## Create the Terraform backend

```bash
./scripts/backend.sh
```

---

## Initialize Terraform

```bash
./scripts/terraform-init.sh
```

---

## Format Terraform code

```bash
terraform fmt
```

---

## Validate configuration

```bash
terraform validate
```

---

## Preview infrastructure

```bash
terraform plan
```

---

## Deploy infrastructure

```bash
terraform apply
```

---

## Destroy infrastructure

```bash
terraform destroy
```

---

# Outputs

After deployment, Terraform returns:

- `app_service_url`
- `function_app_url`
- `container_fqdn`
- `storage_account_name`

Example:

```text
app_service_url      = https://app-hajar-mezouar-tf.azurewebsites.net
function_app_url     = https://fn-hajar-mezouar-tf.azurewebsites.net
container_fqdn       = http://aci-hajar-mezouar-tf.germanywestcentral.azurecontainer.io
storage_account_name = sthajarmezouartf
```

---

# Terraform Concepts Practiced

During this project I practiced:

- Infrastructure as Code (IaC)
- Terraform Providers
- Terraform Modules
- Variables
- Outputs
- Resource Dependencies
- Remote State
- AzureRM Backend
- Azure Blob Storage
- State Migration
- Azure Resource Providers
- Networking
- Bash Automation
- GitHub Actions
- OpenID Connect (OIDC)
- Azure Entra ID
- Federated Credentials
- CI/CD Pipelines

---

# Challenges Encountered

## Azure Resource Provider

The `Microsoft.Storage` resource provider was not registered on the Azure subscription.

**Resolution**

```bash
az provider register --namespace Microsoft.Storage
```

---

## Remote Backend

Migrated from a local Terraform state to an Azure Blob Storage backend.

**Resolution**

Created reusable Bash scripts to automate backend creation and Terraform initialization.

---

## Azure Policy Restrictions

The Azure for Students subscription restricts deployments to a predefined list of Azure regions.

**Resolution**

Inspected the assigned Azure Policy and deployed the infrastructure to an allowed region (`germanywestcentral`).

---

## App Service Capacity

The deployment initially failed in **France Central** because Azure couldn't allocate a **B1 App Service Plan**.

**Resolution**

Redeployed the infrastructure in **Germany West Central**, where capacity was available.

---

## Terraform State Recovery

A partial deployment caused Azure resources to exist while Terraform had not fully recorded them in its state.

**Resolution**

Used Terraform state refresh and resource imports to synchronize the Terraform state with the existing Azure infrastructure.

---

## Bash Automation

Automated backend creation and Terraform initialization using reusable Bash scripts.

---

# Skills Demonstrated

- Infrastructure as Code
- Terraform Module Design
- Azure Administration
- Azure Networking
- Azure Storage
- Azure App Services
- Azure Functions
- Azure Container Instances
- Remote Terraform Backend
- Bash Scripting
- Git Version Control
- Cloud Infrastructure Automation
- GitHub Actions
- CI/CD Pipelines
- OpenID Connect (OIDC)
- Azure Entra ID

---

# Future Improvements

- GitHub Actions CI/CD
- OpenID Connect (OIDC) authentication
- Automated Terraform Format, Validate, Plan and Apply
- Multiple environments (Development, Staging, Production)
- Terraform Workspaces
- Azure Key Vault integration
- Monitoring and Diagnostics