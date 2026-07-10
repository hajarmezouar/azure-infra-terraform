#!/bin/bash

# ==========================================
# Common Configuration
# ==========================================

OWNER="hajar-mezouar"

# Azure Region
LOCATION="germanywestcentral"

# Azure Subscription Name
AZURE_SUBSCRIPTION="Azure for Students"

# Terraform Resource Group
RESOURCE_GROUP="rg-hajar-terraform"

# ==========================================
# Terraform Backend
# ==========================================

RG_BACKEND="rg-tfstate-${OWNER}"
SA_BACKEND="ststate${OWNER//-/}"
CONTAINER_NAME="tfstate"
BACKEND_KEY="${OWNER}.terraform.tfstate"

# ==========================================
# GitHub
# ==========================================

GITHUB_OWNER="hajarmezouar"
GITHUB_REPOSITORY="azure-infra-terraform"

SP_NAME="github-${OWNER}-terraform"

FEDERATED_CREDENTIAL_NAME="github-main"