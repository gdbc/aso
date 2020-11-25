#!/bin/bash

#ref: https://github.com/Azure/azure-service-operator

#kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

#helm repo add azureserviceoperator https://raw.githubusercontent.com/Azure/azure-service-operator/master/charts

# Proceed to create a Az Service Principal
# See url for details then set the below four vars from the sp you created


AZURE_SUBSCRIPTION_ID="1e8b3504-93d8-422d-b5a3-3b3a3aa48ab3"
AZURE_TENANT_ID="7a9376d4-7c43-480f-82ba-a090647f651d"
AZURE_CLIENT_ID="a672704e-7aee-4b05-80b3-3f01b5f845fa"
AZURE_CLIENT_SECRET="y~8tG4T_LI_Ib6ysz.vn4TV9XNilok~ESw"

helm upgrade --install aso https://github.com/Azure/azure-service-operator/raw/master/charts/azure-service-operator-0.1.0.tgz \
        --create-namespace \
        --namespace=azureoperator-system \
        --set azureSubscriptionID=$AZURE_SUBSCRIPTION_ID \
        --set azureTenantID=$AZURE_TENANT_ID \
        --set azureClientID=$AZURE_CLIENT_ID \
        --set azureClientSecret=$AZURE_CLIENT_SECRET \
        --set image.repository="mcr.microsoft.com/k8s/azureserviceoperator:latest"
