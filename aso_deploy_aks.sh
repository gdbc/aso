#!/bin/bash

#ref: https://github.com/Azure/azure-service-operator

# Variables

#AZSP is the name of the service principal you wish use to create infrastructure with in the subscription
AZSP="gdbc-aso-test-sp"

# Deploy cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

# Download repo
helm repo add azureserviceoperator https://raw.githubusercontent.com/Azure/azure-service-operator/master/charts

# Proceed to create a Az Service Principal
# See url for details 

# Set subscription id and az tennant id using existing "default" subscription
read AZURE_SUBSCRIPTION_ID AZURE_TENANT_ID < <(echo $(az account show | jq -r '.id, .tenantId'))

# Create sp and extract App ID and Client secret!
read AZURE_CLIENT_ID AZURE_CLIENT_SECRET < <(echo $(az ad sp create-for-rbac -n $AZSP --role contributor --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID | jq -r '.appId, .password'))

echo "$AZSP AppId: $AZURE_CLIENT_ID"
echo "$AZSP password: $AZURE_CLIENT_SECRET"


helm upgrade --install aso https://github.com/Azure/azure-service-operator/raw/master/charts/azure-service-operator-0.1.0.tgz \
        --create-namespace \
        --namespace=azureoperator-system \
        --set azureSubscriptionID=$AZURE_SUBSCRIPTION_ID \
        --set azureTenantID=$AZURE_TENANT_ID \
        --set azureClientID=$AZURE_CLIENT_ID \
        --set azureClientSecret=$AZURE_CLIENT_SECRET \
        --set image.repository="mcr.microsoft.com/k8s/azureserviceoperator:latest"
