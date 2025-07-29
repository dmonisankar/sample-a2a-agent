#!/bin/bash

# Check IBM Cloud permissions and Code Engine access

echo "🔍 Checking IBM Cloud Authorization for Code Engine"
echo "=================================================="

# Check current user and account
echo "1. Current IBM Cloud Account:"
ibmcloud account show

echo ""
echo "2. Current Target (Region and Resource Group):"
ibmcloud target

echo ""
echo "3. Available Resource Groups:"
ibmcloud resource groups

echo ""
echo "4. User IAM Policies:"
echo "Checking your access policies..."
ibmcloud iam user-policies $(ibmcloud account show --output json | jq -r '.userId') 2>/dev/null || echo "Unable to fetch user policies"

echo ""
echo "5. Code Engine Service Access:"
echo "Checking if Code Engine service is available in your account..."
ibmcloud service list | grep -i "code-engine\|codeengine" || echo "Code Engine service not found in available services"

echo ""
echo "6. Required IAM Roles for Code Engine:"
echo "✅ Manager role on Code Engine service"
echo "✅ Editor role on Resource Group '$RESOURCE_GROUP'"
echo "✅ Viewer role on All Account Management services"

echo ""
echo "🛠️  If you see authorization errors, you need:"
echo "1. Manager access to Code Engine service"
echo "2. Editor access to the resource group"
echo "3. Contact your IBM Cloud administrator to assign these roles"

echo ""
echo "📖 Useful Commands:"
echo "• Check service instances: ibmcloud resource service-instances"
echo "• List IAM access groups: ibmcloud iam access-groups"
echo "• Get help: ibmcloud ce --help"
