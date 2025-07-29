#!/bin/bash

# Alternative deployment approach for limited permissions
# This tries different strategies based on available access

set -e

PROJECT_NAME="currency-agent"
APP_NAME="currency-agent-app"
RESOURCE_GROUP="SRCP_CC_UK"
REGION="us-east"

echo "🔍 Alternative Code Engine Deployment (Limited Permissions)"

# Check if logged into IBM Cloud
if ! ibmcloud account show &>/dev/null; then
    echo "❌ Error: Not logged into IBM Cloud"
    echo "Please run: ibmcloud login"
    exit 1
fi

# Validation
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "❌ Error: GOOGLE_API_KEY environment variable is not set"
    echo "Please run: export GOOGLE_API_KEY='your_api_key'"
    exit 1
fi

echo "🎯 Setting target..."
ibmcloud target -r $REGION -g $RESOURCE_GROUP

echo "📋 Checking existing Code Engine projects..."
ibmcloud ce project list

echo ""
echo "🤔 Trying different approaches..."

# Approach 1: Try to select existing project first
echo "1️⃣ Attempting to select existing project..."
if ibmcloud ce project select --name $PROJECT_NAME; then
    echo "✅ Successfully selected existing project"
    
    # Try to deploy to existing project
    echo "🚀 Deploying to existing project..."
    ibmcloud ce application create \
      --name $APP_NAME \
      --build-source . \
      --build-context-dir samples/python/agents/langgraph \
      --build-dockerfile Containerfile.codeengine \
      --cpu 0.25 \
      --memory 0.5Gi \
      --ephemeral-storage 1Gi \
      --min-scale 0 \
      --max-scale 2 \
      --port 8080 \
      --env GOOGLE_API_KEY="$GOOGLE_API_KEY" \
      --env model_source=google \
      --wait
      
    echo "✅ Deployment successful!"
    ibmcloud ce application get --name $APP_NAME --output url
    
else
    echo "❌ Could not select project. You may need:"
    echo "   • An existing Code Engine project in resource group $RESOURCE_GROUP"
    echo "   • Manager role on Code Engine service"
    echo "   • Editor role on resource group $RESOURCE_GROUP"
    echo ""
    echo "🆘 Next steps:"
    echo "1. Run: ./check-permissions.sh"
    echo "2. Contact your IBM Cloud administrator for proper access"
    echo "3. Or try using a different resource group where you have access"
    exit 1
fi
