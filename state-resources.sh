#!/bin/bash

# Ensure safe execution
set -euxo pipefail

# Log into an Azure tenant using a service principal
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

# Create a new Azure resource group
az group create -n $STATE_RG_NAME -l $LOCATION

# Create a new blob storage account
az storage account create -n $STATE_STOR_NAME -g $STATE_RG_NAME -l $LOCATION --sku Standard_LRS

# Create a container into the newly created storage account
az storage container create -n $CONTAINER_NAME -g $STATE_RG_NAME --account-name $STATE_STOR_NAME
