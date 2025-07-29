#!/bin/bash

# Simple environment setup script for IBM Code Engine deployment
# This version uses environment variables directly instead of secrets

set -e

PROJECT_NAME="currency-agent"
RESOURCE_GROUP="SRCP_CC_UK"  # Should match your deployment script
REGION="us-east"             # Should match your deployment script

echo "🔧 Setting up environment for Currency Agent (Simple Mode)..."

# Check if logged into IBM Cloud
if ! ibmcloud account show &>/dev/null; then
    echo "❌ Please log into IBM Cloud first: ibmcloud login"
    exit 1
fi

# Target the correct region and resource group
echo "🎯 Targeting region: $REGION and resource group: $RESOURCE_GROUP..."
ibmcloud target -r $REGION -g $RESOURCE_GROUP

# Validate API key
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "❌ Please set GOOGLE_API_KEY environment variable"
    echo "Run: export GOOGLE_API_KEY='your_api_key'"
    exit 1
fi

# Select or create project
ibmcloud ce project select --name $PROJECT_NAME 2>/dev/null || {
    echo "📁 Creating new Code Engine project: $PROJECT_NAME"
    ibmcloud ce project create --name $PROJECT_NAME --resource-group $RESOURCE_GROUP
}

echo "✅ Environment setup complete!"
echo "🔍 Project info:"
ibmcloud ce project current

echo ""
echo "💡 Next steps:"
echo "1. Run: ./deploy-codeengine.sh"
echo "2. The deployment will use your GOOGLE_API_KEY environment variable directly"
