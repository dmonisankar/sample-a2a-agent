# IBM Code Engine Deployment Guide

This guide explains how to deploy the Currency Agent (`CurrencyAgentExecutor`) to IBM Code Engine.

## Quick Start

### 1. Prerequisites
```bash
# Install IBM Cloud CLI
curl -fsSL https://clis.cloud.ibm.com/install/osx | sh

# Install Code Engine plugin
ibmcloud plugin install code-engine

# Login to IBM Cloud
ibmcloud login
```

### 2. Environment Setup
```bash
# Set your Google API key
export GOOGLE_API_KEY="your_google_api_key_here"

# Run environment setup
./setup-env.sh
```

### 3. Deploy Application
```bash
# Deploy from source code (recommended)
./deploy-codeengine.sh
```

## Deployment Options

### Option 1: Deploy from Source (Recommended)
This builds the container image directly in Code Engine:
```bash
./deploy-codeengine.sh
```

### Option 2: Deploy from Pre-built Image
If you have a pre-built container image:
```bash
# Update IMAGE_URL in the script first
./deploy-codeengine-image.sh
```

### Option 3: Deploy using YAML Configuration
```bash
# First setup environment
./setup-env.sh

# Apply the configuration
ibmcloud ce application create --config-file codeengine-app.yaml
```

## Configuration

### Environment Variables
- `GOOGLE_API_KEY`: Your Google Gemini API key (required)
- `model_source`: Set to "google" for Google Gemini (default)
- `TOOL_LLM_URL`: Alternative LLM endpoint URL
- `TOOL_LLM_NAME`: Alternative LLM model name

### Scaling Configuration
- **Min Scale**: 0 (scales to zero when not in use)
- **Max Scale**: 5 instances
- **CPU**: 0.25-1 vCPU per instance
- **Memory**: 1-2 GiB per instance
- **Concurrency**: 100 requests per instance

## Application URLs

After deployment, your application will be available at:
```
https://currency-agent-app.{random-id}.{region}.codeengine.appdomain.cloud
```

## Testing the Deployment

Once deployed, test your application:

```bash
# Get the application URL
APP_URL=$(ibmcloud ce application get --name currency-agent-app --output url)

# Test the agent card endpoint
curl "$APP_URL/agent"

# Test a currency conversion
curl -X POST "$APP_URL/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "type": "text/plain",
      "data": "What is the exchange rate from USD to EUR?"
    }
  }'
```

## Monitoring and Troubleshooting

### View Application Status
```bash
ibmcloud ce application get --name currency-agent-app
```

### View Logs
```bash
ibmcloud ce application logs --name currency-agent-app --follow
```

### Scale Application
```bash
# Update scaling parameters
ibmcloud ce application update --name currency-agent-app \
  --min-scale 1 --max-scale 10
```

### Update Environment Variables
```bash
ibmcloud ce application update --name currency-agent-app \
  --env GOOGLE_API_KEY="new_api_key"
```

## Cost Optimization

- **Scale to Zero**: Application automatically scales to 0 when not in use
- **Resource Limits**: Adjust CPU/memory based on actual usage
- **Regional Deployment**: Choose the region closest to your users

## Security Best Practices

1. **Store API keys in secrets**: Use Code Engine secrets for sensitive data
2. **Use IAM roles**: Assign minimal required permissions
3. **Network security**: Configure security groups if needed
4. **Regular updates**: Keep dependencies and base images updated

## Cleanup

To remove the application and project:
```bash
# Delete application
ibmcloud ce application delete --name currency-agent-app

# Delete project (optional)
ibmcloud ce project delete --name currency-agent --force
```
