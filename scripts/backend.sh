#!/bin/bash

set -e

# ==========================================
# Terraform Backend Provisioning
# ==========================================
source "$(dirname "$0")/config.sh"


echo "========================================="
echo "Creating Terraform Backend"
echo "========================================="

echo ""
echo "Creating Resource Group..."

az group create \
    --name "$RG_BACKEND" \
    --location "$LOCATION"

echo ""
echo "Creating Storage Account..."

az storage account create \
    --name "$SA_BACKEND" \
    --resource-group "$RG_BACKEND" \
    --location "$LOCATION" \
    --sku Standard_LRS

echo ""
echo "Creating Blob Container..."

az storage container create \
    --name "$CONTAINER_NAME" \
    --account-name "$SA_BACKEND" \
    --auth-mode login

echo ""
echo "========================================="
echo "Terraform backend created successfully!"
echo "========================================="

echo ""
echo "Resource Group : $RG_BACKEND"
echo "Storage Account: $SA_BACKEND"
echo "Container      : $CONTAINER_NAME"