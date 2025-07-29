#!/bin/bash

# IBM Code Engine Deployment Script - Resource Options
# Different CPU/Memory combinations for different use cases

set -e

# Configuration
PROJECT_NAME="currency-agent"
APP_NAME="currency-agent-app"
RESOURCE_GROUP="SRCP_CC_UK"
REGION="us-east"

# Resource options - uncomment the one you want to use
# Option 1: Minimal resources (cheapest)
CPU="0.125"
MEMORY="0.25Gi"
STORAGE="0.5Gi"

# Option 2: Balanced (recommended)
# CPU="0.5"
# MEMORY="1Gi"
# STORAGE="2Gi"

# Option 3: High performance
# CPU="1"
# MEMORY="2Gi"
# STORAGE="4Gi"

echo "🚀 Deploying Currency Agent with $CPU CPU, $MEMORY memory, and $STORAGE storage..."

# Validation
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "❌ Error: GOOGLE_API_KEY environment variable is not set"
    echo "Please run: export GOOGLE_API_KEY='your_api_key'"
    exit 1
fi

# Check if logged into IBM Cloud
if ! ibmcloud account show &>/dev/null; then
    echo "❌ Error: Not logged into IBM Cloud"
    echo "Please run: ibmcloud login"
    exit 1
fi

# Target the correct region and resource group
echo "🎯 Targeting region: $REGION and resource group: $RESOURCE_GROUP..."
ibmcloud target -r $REGION -g $RESOURCE_GROUP

# Create Code Engine project (if it doesn't exist)
echo "📁 Creating/selecting Code Engine project..."
ibmcloud ce project create --name $PROJECT_NAME --resource-group $RESOURCE_GROUP || \
ibmcloud ce project select --name $PROJECT_NAME

# Build and deploy application from source
echo "🔨 Building and deploying application..."
ibmcloud ce application create \
  --name $APP_NAME \
  --build-source . \
  --build-context-dir samples/python/agents/langgraph \
  --build-dockerfile Containerfile.codeengine \
  --cpu $CPU \
  --memory $MEMORY \
  --ephemeral-storage $STORAGE \
  --min-scale 0 \
  --max-scale 5 \
  --port 8080 \
  --env GOOGLE_API_KEY="$GOOGLE_API_KEY" \
  --env model_source=google \
  --wait

echo "✅ Deployment complete!"
echo "🌐 Application URL:"
ibmcloud ce application get --name $APP_NAME --output url

echo ""
echo "📊 Resource Configuration:"
echo "CPU: $CPU"
echo "Memory: $MEMORY"
echo "Ephemeral Storage: $STORAGE"
echo "Scaling: 0-5 instances"
