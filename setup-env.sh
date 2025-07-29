#!/bin/bash

# Environment setup script for IBM Code Engine deployment

set -e

PROJECT_NAME="currency-agent"
RESOURCE_GROUP="SRCP_CC_UK"  # Should match your deployment script
REGION="us-east"             # Should match your deployment script

echo "🔧 Setting up environment for Currency Agent..."

# Check if logged into IBM Cloud
if ! ibmcloud account show &>/dev/null; then
    echo "❌ Please log into IBM Cloud first: ibmcloud login"
    exit 1
fi

# Target the correct region and resource group
echo "🎯 Targeting region: $REGION and resource group: $RESOURCE_GROUP..."
ibmcloud target -r $REGION -g $RESOURCE_GROUP

# Create secret for API keys
echo "🔐 Creating secrets for API keys..."
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "❌ Please set GOOGLE_API_KEY environment variable"
    exit 1
fi

# Select or create project
ibmcloud ce project select --name $PROJECT_NAME 2>/dev/null || {
    echo "📁 Creating new Code Engine project: $PROJECT_NAME"
    ibmcloud ce project create --name $PROJECT_NAME --resource-group $RESOURCE_GROUP
}

# Create secret for API key using generic format
echo "🔐 Creating secret for API keys..."
ibmcloud ce secret create \
  --name api-keys \
  --format generic \
  --from-literal google-api-key="$GOOGLE_API_KEY" 2>/dev/null || \
{
    echo "🔄 Secret exists, updating..."
    ibmcloud ce secret update \
      --name api-keys \
      --from-literal google-api-key="$GOOGLE_API_KEY"
}

echo "✅ Environment setup complete!"
echo "🔍 Project info:"
ibmcloud ce project current
