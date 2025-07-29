#!/bin/bash

# Troubleshooting script for IBM Code Engine deployment

echo "🔍 IBM Code Engine Deployment Troubleshooting"
echo "=============================================="

# Check IBM Cloud CLI login status
echo "1. Checking IBM Cloud login status..."
if ibmcloud account show &>/dev/null; then
    echo "✅ Logged into IBM Cloud"
    ibmcloud account show
else
    echo "❌ Not logged into IBM Cloud"
    echo "Run: ibmcloud login"
    exit 1
fi

echo ""

# Check current target
echo "2. Checking current target..."
echo "Current target:"
ibmcloud target

echo ""

# Check available regions for Code Engine
echo "3. Available Code Engine regions..."
echo "Run this command to see available regions:"
echo "ibmcloud ce project create --help | grep -A 10 'Valid values'"

echo ""

# Check resource groups
echo "4. Available resource groups..."
ibmcloud resource groups

echo ""

# Check existing Code Engine projects
echo "5. Existing Code Engine projects..."
ibmcloud ce project list

echo ""

# Environment variables check
echo "6. Environment variables check..."
if [ -z "$GOOGLE_API_KEY" ]; then
    echo "❌ GOOGLE_API_KEY not set"
else
    echo "✅ GOOGLE_API_KEY is set"
fi

echo ""

echo "🛠️  Recommended actions:"
echo "1. Set your target: ibmcloud target -r REGION -g RESOURCE_GROUP"
echo "2. Valid regions: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd"
echo "3. Set API key: export GOOGLE_API_KEY='your_key'"
echo "4. Run setup: ./setup-env.sh"
echo "5. Deploy: ./deploy-codeengine.sh"
