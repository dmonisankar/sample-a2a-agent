# IBM Code Engine Permission Issues - Troubleshooting Guide

## 🚨 **Authorization Error: "This action is forbidden"**

This error means your IBM Cloud account doesn't have sufficient permissions for Code Engine operations.

## 🔍 **Step 1: Check Your Current Access**

Run the permission checker:
```bash
./check-permissions.sh
```

## 🛠️ **Step 2: Required IAM Roles**

To deploy to IBM Code Engine, you need these roles:

### **For Code Engine Service:**
- **Manager** role on Code Engine service
- **Editor** role on Code Engine service (minimum)

### **For Resource Group:**
- **Editor** role on resource group `SRCP_CC_UK`
- **Viewer** role on resource group (minimum)

### **For Container Registry (if using):**
- **Manager** role on Container Registry service

## 📞 **Step 3: Request Access from Administrator**

Send this to your IBM Cloud account administrator:

---

**Subject:** Request for IBM Code Engine Access

Hi [Administrator],

I need access to deploy applications using IBM Code Engine. Please assign the following IAM roles to my account:

**User ID:** [Your IBM Cloud User ID - get from `ibmcloud account show`]

**Required Roles:**
1. **Code Engine Service:** Manager role
2. **Resource Group `SRCP_CC_UK`:** Editor role  
3. **Container Registry:** Manager role (if using container builds)

**Use Case:** Deploying a Currency Agent application to Code Engine

**Resource Group:** SRCP_CC_UK
**Region:** us-east

Thank you!

---

## 🔄 **Step 4: Alternative Approaches**

### **Option A: Use Existing Project**
If there's already a Code Engine project you have access to:
```bash
./deploy-limited-permissions.sh
```

### **Option B: Try Different Resource Group**
Check available resource groups:
```bash
ibmcloud resource groups
```

Update the scripts to use a resource group where you have Editor access.

### **Option C: Use IBM Cloud Console**
1. Go to [IBM Cloud Console](https://cloud.ibm.com)
2. Navigate to Code Engine
3. Try creating a project through the UI
4. This might show more specific permission errors

## 🏥 **Step 5: Self-Service Options**

### **Check Access Groups:**
```bash
ibmcloud iam access-groups
```

### **Check Your Policies:**
```bash
ibmcloud iam user-policies [your-user-id]
```

### **Try Different Regions:**
Some regions might have different permission requirements:
- us-south (Dallas)
- eu-gb (London)  
- eu-de (Frankfurt)

## 📖 **Useful IBM Cloud Documentation**

- [Code Engine IAM Roles](https://cloud.ibm.com/docs/codeengine?topic=codeengine-iam)
- [Managing Access](https://cloud.ibm.com/docs/account?topic=account-assign-access-resources)
- [Resource Groups](https://cloud.ibm.com/docs/account?topic=account-rgs)

## 🆘 **If Still Stuck**

1. **Contact IBM Support:** If you're on a paid plan
2. **Check Company Policies:** Your organization might have specific approval processes
3. **Use Alternative Deployment:** Consider other platforms like IBM Cloud Foundry or Container Service
