# Login
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

# Create Resource Group
az group create -n $STATE_RG_NAME -l westeurope

# Create Storage Account
az storage account create -n $STATE_STOR_NAME -g $STATE_RG_NAME -l westeurope --sku Standard_LRS

# Create Storage Account Container
az storage container create -n $CONTAINER_NAME -g $STATE_RG_NAME --account-name $STATE_STOR_NAME
