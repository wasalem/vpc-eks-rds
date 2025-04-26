cat << 'EOF' > README.md
# EKS and RDS in the Same VPC - Terraform Deployment

## Overview
This Terraform project deploys an Amazon EKS cluster and an RDS database instance within the same VPC, configured with proper networking and security settings for secure communication between the Kubernetes cluster and the database.

## Key Features

### Network Architecture
- **VPC with Public/Private Subnets**: Deploys across 2 availability zones for high availability
- **NAT Gateway**: Enables outbound internet access for private subnets
- **Proper Subnet Tagging**: Required for EKS and internal load balancers

### EKS Cluster
- **Managed Node Groups**: Worker nodes automatically distributed across AZs
- **Essential Add-ons**: CoreDNS, kube-proxy, and VPC CNI pre-configured
- **Auto-scaling**: Worker nodes configured to scale based on demand

### RDS Database
- **PostgreSQL**: Default engine (configurable to MySQL, Aurora, etc.)
- **Multi-AZ Deployment**: High availability configuration
- **Private Subnet Placement**: Database not publicly accessible
- **Custom Security Group**: Restricts access to EKS worker nodes only

### Integration
- **Automatic Secret Creation**: Database credentials stored as Kubernetes secret
- **Secure Communication**: Proper security group rules between EKS and RDS
- **Output Variables**: Easy access to critical endpoints and credentials

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** (v1.0.0 or later) installed
3. **AWS CLI** configured with credentials
4. **kubectl** installed for Kubernetes management
5. **eksctl** (optional) for additional EKS management

## Deployment Steps

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Review Execution Plan
```bash
terraform plan
```

### 4. Apply the Configuration
```bash
terraform apply
```

You will be prompted to:
  1. Confirm the action
  2. Provide values for any undefined variables (like db_password)

### 5. Configure kubectl
After deployment completes, configure kubectl to access your new cluster:

```bash
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

### 6. Verify Deployment
Check that the Kubernetes secret was created:

```bash
kubectl get secret db-credentials -o yaml
```

## Post-Deployment Configuration

### Accessing the Database from Applications
Use the automatically created Kubernetes secret in your application deployments:

```yaml
env:
- name: DB_HOST
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: host
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: username
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: password
- name: DB_NAME
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: dbname
```
### Retrieving Connection Information
Get database connection details:

```bash
echo "RDS Endpoint: $(terraform output -raw rds_endpoint)"
echo "RDS Port: $(terraform output -raw rds_port)"
echo "RDS Username: $(terraform output -raw rds_username)"
```

## Customization Options
### Variables to Modify
Edit variables.tf to customize:
* AWS region
* Cluster name
* Database credentials
* Instance types
* Storage sizes

### Database Configuration
Modify rds.tf to:
* Change database engine (MySQL, Aurora, etc.)
* Adjust storage parameters
* Enable enhanced monitoring

### EKS Configuration
Modify eks.tf to:
* Change Kubernetes version
* Add additional node groups
* Configure cluster autoscaler

## Cleanup
To destroy all created resources:

```bash
terraform destroy
```

## Security Notes
1. Database credentials are stored in Terraform state and Kubernetes secrets
2. For production use, consider:
    * Using AWS Secrets Manager instead of Kubernetes secrets
    * Enabling RDS encryption
    * Implementing more granular IAM policies

## Support
For issues or questions, please open an issue in the repository.