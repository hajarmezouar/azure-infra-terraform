#!/bin/bash

# ==========================================
# Common Configuration
# ==========================================

OWNER="hajar-mezouar"

# Azure region
LOCATION="francecentral"

# Terraform infrastructure Resource Group
RESOURCE_GROUP="hmezouarRG"

# Terraform backend
RG_BACKEND="rg-tfstate-${OWNER}"
SA_BACKEND="ststate${OWNER//-/}"
CONTAINER_NAME="tfstate"
BACKEND_KEY="${OWNER}.terraform.tfstate"