#!/bin/bash

# IBM Code Engine Deployment Script for Currency Agent
# Make sure you're logged into IBM Cloud: ibmcloud login

set -e

# Configuration
PROJECT_NAME="currency-agent"
APP_NAME="currency-agent-new5-app"
RESOURCE_GROUP="SRCP_CC_UK"  # Change to your resource group
REGION="us-east"         # Valid regions: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd

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

echo "🚀 Deploying Currency Agent to IBM Code Engine..."

# Target the correct region and resource group
echo "🎯 Targeting region: $REGION and resource group: $RESOURCE_GROUP..."
ibmcloud target -r $REGION -g $RESOURCE_GROUP

# Create Code Engine project (if it doesn't exist)
echo "📁 Creating/selecting Code Engine project..."
ibmcloud ce project create --name $PROJECT_NAME  || \
ibmcloud ce project select --name $PROJECT_NAME

# Build and deploy application from source
echo "🔨 Building and deploying application..."
# Valid CPU/Memory/Ephemeral Storage combinations for IBM Code Engine:
# 0.125 vCPU: 0.25Gi memory, 0.5Gi storage OR 0.5Gi memory, 1Gi storage
# 0.25 vCPU:  0.5Gi memory, 1Gi storage OR 1Gi memory, 2Gi storage
# 0.5 vCPU:   1Gi memory, 2Gi storage OR 2Gi memory, 4Gi storage
# 1 vCPU:     2Gi memory, 4Gi storage OR 4Gi memory, 8Gi storage
# 2 vCPU:     4Gi memory, 8Gi storage OR 8Gi memory, 16Gi storage
# 4 vCPU:     8Gi memory, 16Gi storage OR 16Gi memory, 32Gi storage
ibmcloud ce application create \
  --name $APP_NAME \
  --build-source . \
  --build-context-dir . \
  --build-dockerfile Containerfile.codeengine \
  --cpu 1 \
  --memory 4G \
  --min-scale 1 \
  --max-scale 2 \
  --port 8080 \
  --env GOOGLE_API_KEY="$GOOGLE_API_KEY" \
  --env model_source=google \
  --env AGENT_URL="https://$APP_NAME.1yep95hyxos1.us-east.codeengine.appdomain.cloud/" \
  --wait

echo "✅ Deployment complete!"
echo "🌐 Application URL:"
ibmcloud ce application get --name $APP_NAME --output url
