#!/bin/bash

# Deploy using pre-built container image
# First build and push your image to IBM Container Registry or Docker Hub

set -e

PROJECT_NAME="currency-agent"
APP_NAME="currency-agent-app"
IMAGE_URL="your-registry/currency-agent:latest"  # Update with your image URL

echo "🚀 Deploying Currency Agent from container image..."

# Select project
ibmcloud ce project select --name $PROJECT_NAME

# Deploy application from container image
ibmcloud ce application create \
  --name $APP_NAME \
  --image $IMAGE_URL \
  --cpu 1 \
  --memory 2Gi \
  --min-scale 0 \
  --max-scale 5 \
  --port 8080 \
  --env GOOGLE_API_KEY="$GOOGLE_API_KEY" \
  --env model_source=google \
  --wait

echo "✅ Deployment complete!"
ibmcloud ce application get --name $APP_NAME --output url
