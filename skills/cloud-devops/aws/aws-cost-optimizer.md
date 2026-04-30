---
name: aws-cost-optimizer
description: "Comprehensive AWS cost analysis and optimization recommendations using AWS CLI and Cost Explorer"
risk: safe
source: community
date_added: "2026-02-27"
---

# AWS Cost Optimizer

Analyze AWS spending patterns, identify waste, and provide actionable cost reduction strategies.

## When to Use This Skill

Use this skill when you need to analyze AWS spending, identify cost optimization opportunities, or reduce cloud waste.

## Core Capabilities

**Cost Analysis**
- Parse AWS Cost Explorer data for trends and anomalies
- Break down costs by service, region, and resource tags
- Identify month-over-month spending increases

**Resource Optimization**
- Detect idle EC2 instances (low CPU utilization)
- Find unattached EBS volumes and old snapshots
- Identify unused Elastic IPs
- Locate underutilized RDS instances
- Find old S3 objects eligible for lifecycle policies

**Savings Recommendations**
- Suggest Reserved Instance/Savings Plans opportunities
- Recommend instance rightsizing based on CloudWatch metrics
- Identify resources in expensive regions
- Calculate potential savings with specific actions

## AWS CLI Commands

### Get Cost and Usage
```bash
# Last 30 days cost by service
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '30 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE

# Daily costs for current month
aws ce get-cost-and-usage \
  --time-period Start=$(date +%Y-%m-01),End=$(date +%Y-%m-%d) \
  --granularity DAILY \
  --metrics UnblendedCost
```

### Find Unused Resources
```bash
# Unattached EBS volumes
aws ec2 describe-volumes \
  --filters Name=status,Values=available \
  --query 'Volumes[*].[VolumeId,Size,VolumeType,CreateTime]' \
  --output table

# Unused Elastic IPs
aws ec2 describe-addresses \
  --query 'Addresses[?AssociationId==null].[PublicIp,AllocationId]' \
  --output table

# Idle EC2 instances (requires CloudWatch)
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-xxxxx \
  --start-time $(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 86400 \
  --statistics Average

# Old EBS snapshots (>90 days)
aws ec2 describe-snapshots \
  --owner-ids self \
  --query 'Snapshots[?StartTime<=`'$(date -d '90 days ago' --iso-8601)'`].[SnapshotId,StartTime,VolumeSize]' \
  --output table
```

### Rightsizing Analysis
```bash
# List EC2 instances with their types
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# Get RDS instance utilization
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBInstanceIdentifier,Value=mydb \
  --start-time $(date -u -d '30 days ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 86400 \
  --statistics Average,Maximum
```

## Optimization Workflow

1. **Baseline Assessment**
   - Pull 3-6 months of cost data
   - Identify top 5 spending services
   - Calculate growth rate

2. **Quick Wins**
   - Delete unattached EBS volumes
   - Release unused Elastic IPs
   - Stop/terminate idle EC2 instances
   - Delete old snapshots

3. **Strategic Optimization**
   - Analyze Reserved Instance coverage
   - Review instance types vs. workload
   - Implement S3 lifecycle policies
   - Consider Spot instances for non-critical workloads

4. **Ongoing Monitoring**
   - Set up AWS Budgets with alerts
   - Enable Cost Anomaly Detection
   - Tag resources for cost allocation
   - Monthly cost review meetings

## Cost Optimization Checklist

- [ ] Enable AWS Cost Explorer
- [ ] Set up cost allocation tags
- [ ] Create AWS Budget with alerts
- [ ] Review and delete unused resources
- [ ] Analyze Reserved Instance opportunities
- [ ] Implement S3 Intelligent-Tiering
- [ ] Review data transfer costs
- [ ] Optimize Lambda memory allocation
- [ ] Use CloudWatch Logs retention policies
- [ ] Consider multi-region cost differences

## Example Prompts

**Analysis**
- "Show me AWS costs for the last 3 months broken down by service"
- "What are my top 10 most expensive resources?"
- "Compare this month's spending to last month"

**Optimization**
- "Find all unattached EBS volumes and calculate savings"
- "Identify EC2 instances with <5% CPU utilization"
- "Suggest Reserved Instance purchases based on usage"
- "Calculate savings from deleting snapshots older than 90 days"

**Implementation**
- "Create a script to delete unattached volumes"
- "Set up a budget alert for $1000/month"
- "Generate a cost optimization report for leadership"

## Best Practices

- Always test in non-production first
- Verify resources are truly unused before deletion
- Document all cost optimization actions
- Calculate ROI for optimization efforts
- Automate recurring optimization tasks
- Use AWS Trusted Advisor recommendations
- Enable AWS Cost Anomaly Detection

## Integration with Kiro CLI

This skill works seamlessly with Kiro CLI's AWS integration:

```bash
# Use Kiro to analyze costs
kiro-cli chat "Use aws-cost-optimizer to analyze my spending"

# Generate optimization report
kiro-cli chat "Create a cost optimization plan using aws-cost-optimizer"
```

## Safety Notes

- **Risk Level: Low** - Read-only analysis is safe
- **Deletion Actions: Medium Risk** - Always verify before deleting resources
- **Production Changes: High Risk** - Test rightsizing in dev/staging first
- Maintain backups before any deletion
- Use `--dry-run` flag when available

## Additional Resources

- [AWS Cost Optimization Best Practices](https://aws.amazon.com/pricing/cost-optimization/)
- [AWS Well-Architected Framework - Cost Optimization](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/welcome.html)
- [AWS Cost Explorer API](https://docs.aws.amazon.com/cost-management/latest/APIReference/Welcome.html)

## Limitations
- Use this skill only when the task clearly matches the scope described above.
- Do not treat the output as a substitute for environment-specific validation, testing, or expert review.
- Stop and ask for clarification if required inputs, permissions, safety boundaries, or success criteria are missing.


---

## Merged Content from cloud-devops/aws-cost-cleanup.md

---
name: aws-cost-cleanup
description: "Automated cleanup of unused AWS resources to reduce costs"
risk: safe
source: community
date_added: "2026-02-27"
---

# AWS Cost Cleanup

Automate the identification and removal of unused AWS resources to eliminate waste.

## When to Use This Skill

Use this skill when you need to automatically clean up unused AWS resources to reduce costs and eliminate waste.

## Automated Cleanup Targets

**Storage**
- Unattached EBS volumes
- Old EBS snapshots (>90 days)
- Incomplete multipart S3 uploads
- Old S3 versions in versioned buckets

**Compute**
- Stopped EC2 instances (>30 days)
- Unused AMIs and associated snapshots
- Unused Elastic IPs

**Networking**
- Unused Elastic Load Balancers
- Unused NAT Gateways
- Orphaned ENIs

## Cleanup Scripts

### Safe Cleanup (Dry-Run First)

```bash
#!/bin/bash
# cleanup-unused-ebs.sh

echo "Finding unattached EBS volumes..."
VOLUMES=$(aws ec2 describe-volumes \
  --filters Name=status,Values=available \
  --query 'Volumes[*].VolumeId' \
  --output text)

for vol in $VOLUMES; do
  echo "Would delete: $vol"
  # Uncomment to actually delete:
  # aws ec2 delete-volume --volume-id $vol
done
```

```bash
#!/bin/bash
# cleanup-old-snapshots.sh

CUTOFF_DATE=$(date -d '90 days ago' --iso-8601)

aws ec2 describe-snapshots --owner-ids self \
  --query "Snapshots[?StartTime<='$CUTOFF_DATE'].[SnapshotId,StartTime,VolumeSize]" \
  --output text | while read snap_id start_time size; do
  
  echo "Snapshot: $snap_id (Created: $start_time, Size: ${size}GB)"
  # Uncomment to delete:
  # aws ec2 delete-snapshot --snapshot-id $snap_id
done
```

```bash
#!/bin/bash
# release-unused-eips.sh

aws ec2 describe-addresses \
  --query 'Addresses[?AssociationId==null].[AllocationId,PublicIp]' \
  --output text | while read alloc_id public_ip; do
  
  echo "Would release: $public_ip ($alloc_id)"
  # Uncomment to release:
  # aws ec2 release-address --allocation-id $alloc_id
done
```

### S3 Lifecycle Automation

```bash
# Apply lifecycle policy to transition old objects to cheaper storage
cat > lifecycle-policy.json <<EOF
{
  "Rules": [
    {
      "Id": "Archive old objects",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 90,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 180,
          "StorageClass": "GLACIER"
        }
      ],
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 30
      },
      "AbortIncompleteMultipartUpload": {
        "DaysAfterInitiation": 7
      }
    }
  ]
}
EOF

aws s3api put-bucket-lifecycle-configuration \
  --bucket my-bucket \
  --lifecycle-configuration file://lifecycle-policy.json
```

## Cost Impact Calculator

```python
#!/usr/bin/env python3
# calculate-savings.py

import boto3
from datetime import datetime, timedelta

ec2 = boto3.client('ec2')

# Calculate EBS volume savings
volumes = ec2.describe_volumes(
    Filters=[{'Name': 'status', 'Values': ['available']}]
)

total_size = sum(v['Size'] for v in volumes['Volumes'])
monthly_cost = total_size * 0.10  # $0.10/GB-month for gp3

print(f"Unattached EBS Volumes: {len(volumes['Volumes'])}")
print(f"Total Size: {total_size} GB")
print(f"Monthly Savings: ${monthly_cost:.2f}")

# Calculate Elastic IP savings
addresses = ec2.describe_addresses()
unused = [a for a in addresses['Addresses'] if 'AssociationId' not in a]

eip_cost = len(unused) * 3.65  # $0.005/hour * 730 hours
print(f"\nUnused Elastic IPs: {len(unused)}")
print(f"Monthly Savings: ${eip_cost:.2f}")

print(f"\nTotal Monthly Savings: ${monthly_cost + eip_cost:.2f}")
print(f"Annual Savings: ${(monthly_cost + eip_cost) * 12:.2f}")
```

## Automated Cleanup Lambda

```python
import boto3
from datetime import datetime, timedelta

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    # Delete unattached volumes older than 7 days
    volumes = ec2.describe_volumes(
        Filters=[{'Name': 'status', 'Values': ['available']}]
    )
    
    cutoff = datetime.now() - timedelta(days=7)
    deleted = 0
    
    for vol in volumes['Volumes']:
        create_time = vol['CreateTime'].replace(tzinfo=None)
        if create_time < cutoff:
            try:
                ec2.delete_volume(VolumeId=vol['VolumeId'])
                deleted += 1
                print(f"Deleted volume: {vol['VolumeId']}")
            except Exception as e:
                print(f"Error deleting {vol['VolumeId']}: {e}")
    
    return {
        'statusCode': 200,
        'body': f'Deleted {deleted} volumes'
    }
```

## Cleanup Workflow

1. **Discovery Phase** (Read-only)
   - Run all describe commands
   - Generate cost impact report
   - Review with team

2. **Validation Phase**
   - Verify resources are truly unused
   - Check for dependencies
   - Notify resource owners

3. **Execution Phase** (Dry-run first)
   - Run cleanup scripts with dry-run
   - Review proposed changes
   - Execute actual cleanup

4. **Verification Phase**
   - Confirm deletions
   - Monitor for issues
   - Document savings

## Safety Checklist

- [ ] Run in dry-run mode first
- [ ] Verify resources have no dependencies
- [ ] Check resource tags for ownership
- [ ] Notify stakeholders before deletion
- [ ] Create snapshots of critical data
- [ ] Test in non-production first
- [ ] Have rollback plan ready
- [ ] Document all deletions

## Example Prompts

**Discovery**
- "Find all unused resources and calculate potential savings"
- "Generate a cleanup report for my AWS account"
- "What resources can I safely delete?"

**Execution**
- "Create a script to cleanup unattached EBS volumes"
- "Delete all snapshots older than 90 days"
- "Release unused Elastic IPs"

**Automation**
- "Set up automated cleanup for old snapshots"
- "Create a Lambda function for weekly cleanup"
- "Schedule monthly resource cleanup"

## Integration with AWS Organizations

```bash
# Run cleanup across multiple accounts
for account in $(aws organizations list-accounts \
  --query 'Accounts[*].Id' --output text); do
  
  echo "Checking account: $account"
  aws ec2 describe-volumes \
    --filters Name=status,Values=available \
    --profile account-$account
done
```

## Monitoring and Alerts

```bash
# Create CloudWatch alarm for cost anomalies
aws cloudwatch put-metric-alarm \
  --alarm-name high-cost-alert \
  --alarm-description "Alert when daily cost exceeds threshold" \
  --metric-name EstimatedCharges \
  --namespace AWS/Billing \
  --statistic Maximum \
  --period 86400 \
  --evaluation-periods 1 \
  --threshold 100 \
  --comparison-operator GreaterThanThreshold
```

## Best Practices

- Schedule cleanup during maintenance windows
- Always create final snapshots before deletion
- Use resource tags to identify cleanup candidates
- Implement approval workflow for production
- Log all cleanup actions for audit
- Set up cost anomaly detection
- Review cleanup results weekly

## Risk Mitigation

**Medium Risk Actions:**
- Deleting unattached volumes (ensure no planned reattachment)
- Removing old snapshots (verify no compliance requirements)
- Releasing Elastic IPs (check DNS records)

**Always:**
- Maintain 30-day backup retention
- Use AWS Backup for critical resources
- Test restore procedures
- Document cleanup decisions

## Kiro CLI Integration

```bash
# Analyze and cleanup in one command
kiro-cli chat "Use aws-cost-cleanup to find and remove unused resources"

# Generate cleanup script
kiro-cli chat "Create a safe cleanup script for my AWS account"

# Schedule automated cleanup
kiro-cli chat "Set up weekly automated cleanup using aws-cost-cleanup"
```

## Additional Resources

- [AWS Resource Cleanup Best Practices](https://aws.amazon.com/blogs/mt/automate-resource-cleanup/)
- [AWS Systems Manager Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)
- [AWS Config Rules for Compliance](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html)

## Limitations
- Use this skill only when the task clearly matches the scope described above.
- Do not treat the output as a substitute for environment-specific validation, testing, or expert review.
- Stop and ask for clarification if required inputs, permissions, safety boundaries, or success criteria are missing.
