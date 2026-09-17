# AWS Terraform Enterprise Lab

A hands-on AWS/Terraform enterprise infrastructure lab demonstrating remote Terraform state management, shared networking, environment separation, GitHub Actions CI/CD, GitHub OIDC authentication, least-privilege IAM, deployment controls, and Terraform state protection.

## 1. Objectives

This lab demonstrates:

- Centralized remote Terraform state
- S3 state versioning and locking
- Separate Terraform states for shared infrastructure and environments
- One shared VPC consumed by environment configurations
- AWS-managed/default encryption
- GitHub Actions CI validation
- GitHub OIDC authentication to AWS
- Environment-specific IAM roles
- Least-privilege Terraform state access
- Manual deployment and promotion workflows
- Main-branch deployment restrictions
- Terraform destroy safeguards
- Terraform state recovery procedures
- Reusable Terraform modules

## 2. Architecture

```text
                         GitHub Repository
                    aws-terraform-enterprise-lab
                              |
                    GitHub Actions + OIDC
                              |
          +-------------------+-------------------+
          |                   |                   |
          v                   v                   v
       Shared               Dev              Staging / Prod
        Role                Role                  Roles
          |                   |                   |
          v                   v                   v
 infrastructure/         environments/       environments/
     shared/                  dev/          staging/ / prod/
          |                   |                   |
          +-------------------+-------------------+
                              |
                              v
                    Central Terraform State
                         Amazon S3
                              |
                              +-- infrastructure/networking/
                              |      terraform.tfstate
                              |
                              +-- environments/dev/
                              |      terraform.tfstate
                              |
                              +-- environments/staging/
                              |      terraform.tfstate
                              |
                              +-- environments/prod/
                                     terraform.tfstate
```

### Shared networking

The shared infrastructure contains one VPC:

```text
Region: ap-south-1
VPC CIDR: 10.20.0.0/22

Availability Zones:
  - ap-south-1a
  - ap-south-1b

Public subnets:
  - 10.20.0.0/24
  - 10.20.1.0/24

Private subnets:
  - 10.20.2.0/24
  - 10.20.3.0/24

NAT Gateways:
  - 1

Elastic IPs:
  - 1
```

## 3. Current Infrastructure Scope

The current baseline contains **shared networking only**.

The following temporary/application resources were intentionally removed:

- Application Load Balancer
- RDS
- DynamoDB application resources
- Secrets Manager application resources
- Auto Scaling Group
- WAF
- DEV application resources
- Other temporary application-specific resources

They must not be recreated unless explicitly required for a future phase.

The `dev`, `staging`, and `prod` environment states remain independent and are currently intended to be empty/no-op.

## 4. Repository Structure

```text
aws-terraform-enterprise-lab/
│
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml
│       ├── terraform-deploy.yml
│       ├── terraform-promote.yml
│       ├── terraform-destroy.yml
│       └── terraform-shared.yml
│
├── bootstrap/
│   └── terraform-state/
│
├── infrastructure/
│   └── shared/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── data.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   │
│   ├── staging/
│   │   ├── backend.tf
│   │   ├── data.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   │
│   └── prod/
│       ├── backend.tf
│       ├── data.tf
│       ├── variables.tf
│       └── versions.tf
│
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── iam/
│   ├── github-actions-terraform-shared-trust.json
│   └── policies/
│       ├── github-actions-terraform-dev.json
│       ├── github-actions-terraform-staging.json
│       ├── github-actions-terraform-prod.json
│       ├── github-actions-terraform-shared.json
│       └── terraform-state-bucket-policy.json
│
├── docs/
│   └── terraform-state-recovery.md
│
├── .gitignore
├── .terraform-version
└── README.md
```

## 5. Terraform Version and Provider

Terraform:

```text
1.15.0
```

AWS provider:

```text
~> 6.0
```

AWS region for the lab:

```text
ap-south-1
```

The AWS CLI default region is not changed by this project.

## 6. Terraform State Architecture

Terraform state is centralized in an Amazon S3 backend.

The bootstrap layer creates the backend resources before the other Terraform configurations use them.

```text
bootstrap
   |
   +-- S3 Terraform state bucket
   |
   +-- DynamoDB lock table
```

The current S3 backend uses:

```hcl
use_lockfile = true
encrypt      = true
```

The DynamoDB lock table remains part of the bootstrap foundation but is not used by the current S3 lockfile mechanism.

### State separation

```text
infrastructure/networking
    -> shared infrastructure state

environments/dev
    -> dev state

environments/staging
    -> staging state

environments/prod
    -> prod state
```

This prevents shared and environment state from being mixed.

## 7. Shared Terraform State Consumption

Environment configurations consume shared outputs through:

```hcl
data "terraform_remote_state" "shared"
```

Shared outputs include:

- VPC ID
- VPC ARN
- VPC CIDR
- Public subnet IDs
- Private subnet IDs
- Route table IDs
- NAT Gateway IDs
- Internet Gateway ID

Environment roles therefore require:

- Read/write access to their own state
- Read-only access to shared state
- No write access to shared state
- No access to another environment's state

## 8. Shared VPC Module

The VPC is implemented as a reusable module:

```text
modules/vpc/
```

The shared root composes the module:

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name = "${var.project_name}-shared"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  nat_gateway_count  = var.nat_gateway_count

  tags = {
    Component = "networking"
    Tier      = "shared"
    Purpose   = "shared-network"
  }
}
```

The deliberate VPC CIDR is:

```text
10.20.0.0/22
```

It must not be changed without an explicit architecture decision.

## 9. GitHub Actions CI

Workflow:

```text
.github/workflows/terraform-ci.yml
```

The CI workflow runs on pull requests targeting `main`.

It validates:

```text
infrastructure/networking
environments/dev
environments/staging
environments/prod
```

Checks:

1. Terraform format check
2. Terraform initialization without backend access
3. Terraform validation
4. TFLint initialization
5. TFLint execution

CI does not deploy infrastructure.

Checkov and additional security scanning are intentionally outside the current baseline phase.

## 10. GitHub OIDC

GitHub Actions authenticates to AWS through OIDC.

Static AWS access keys are not used.

The repository is:

```text
sm-joe/aws-terraform-enterprise-lab
```

Immutable GitHub identifiers:

```text
Owner ID:       146173441
Repository ID:  1371559964
```

Required subject:

```text
repo:sm-joe@146173441/aws-terraform-enterprise-lab@1371559964:ref:refs/heads/main
```

The trust relationship is branch-based.

Environment-based OIDC subjects are intentionally not used.

## 11. GitHub Actions IAM Roles

Four deployment roles are used:

```text
GitHubActions-Terraform-Shared
GitHubActions-Terraform-Dev
GitHubActions-Terraform-Staging
GitHubActions-Terraform-Prod
```

### Shared

Manages:

```text
Shared Terraform state
Shared VPC networking
```

### Dev

Manages:

```text
Dev Terraform state
Read-only shared Terraform state
```

### Staging

Manages:

```text
Staging Terraform state
Read-only shared Terraform state
```

### Prod

Manages:

```text
Prod Terraform state
Read-only shared Terraform state
```

No environment role should access another environment's state.

## 12. Least-Privilege IAM

Broad permissions were used temporarily during initial pipeline setup.

They were replaced with dedicated least-privilege policies.

Environment roles require:

```text
S3 bucket:
  GetBucketLocation
  ListBucket

Own environment state:
  GetObject
  PutObject
  DeleteObject

Own environment lock file:
  GetObject
  PutObject
  DeleteObject

Shared state:
  GetObject only
```

The shared role additionally has the EC2 API permissions required for the shared VPC networking resources.

No customer-managed KMS permissions are required because AWS-managed/default S3 encryption is used.

## 13. Deployment Workflows

### Shared

Workflow:

```text
terraform-shared.yml
```

Process:

```text
Terraform init
Terraform plan
Terraform apply
```

Uses:

```text
GitHubActions-Terraform-Shared
```

### DEV

Workflow:

```text
terraform-deploy.yml
```

Process:

```text
Terraform init
Terraform plan
Terraform apply
```

Uses:

```text
GitHubActions-Terraform-Dev
```

The workflow is restricted to `main`.

### Staging and Production

Workflow:

```text
terraform-promote.yml
```

The current promotion workflow uses a direct:

```text
Terraform init
Terraform plan
Terraform apply
```

There is intentionally no artifact-based plan transfer and no `plan_run_id`.

Environment selection:

```text
staging
prod
```

Role mapping:

```text
staging -> GitHubActions-Terraform-Staging
prod    -> GitHubActions-Terraform-Prod
```

The workflow is restricted to `main`.

## 14. Destroy Workflow

Workflow:

```text
terraform-destroy.yml
```

Destroy operations require:

```text
Environment selection
+
Exact confirmation:
DESTROY
```

Process:

```text
Validate branch
Validate DESTROY confirmation
Terraform init
Terraform destroy plan
Terraform destroy apply
```

The destroy plan and apply occur within the same workflow run using the generated destroy plan artifact.

## 15. GitHub Environment Restrictions

GitHub environments:

```text
dev
staging
prod
```

Deployment branch restrictions:

```text
dev:
  No restriction

staging:
  Selected branches/tags -> main

prod:
  Selected branches/tags -> main
```

Workflows additionally verify:

```text
refs/heads/main
```

before deployment.

## 16. Main Branch Protection

The `main` branch is protected through GitHub repository rules.

Configured controls include:

- Pull request required
- At least one approval
- Terraform CI status check
- Force pushes blocked
- Branch deletion restricted
- Conversation resolution where supported
- Stale approval dismissal where appropriate

This prevents unvalidated Terraform changes from being merged directly into `main`.

## 17. Terraform State S3 Security

The Terraform state bucket is protected with:

### Versioning

Enabled to preserve historical state versions.

### Public access blocking

All four S3 public-access-block settings are enabled:

```text
BlockPublicAcls
IgnorePublicAcls
BlockPublicPolicy
RestrictPublicBuckets
```

### Object ownership

```text
BucketOwnerEnforced
```

### Encryption

Server-side encryption is enabled using AWS-managed/default S3 encryption.

Customer-managed KMS keys are intentionally not used.

### HTTPS-only access

The bucket policy denies S3 operations when:

```text
aws:SecureTransport = false
```

## 18. State Version Retention

S3 versioning is combined with lifecycle management.

Noncurrent state versions are retained for:

```text
365 days
```

Current versions are not automatically expired by this lifecycle rule.

## 19. Terraform State Recovery

Recovery documentation:

```text
docs/terraform-state-recovery.md
```

Recovery model:

```text
S3 versioning
      |
      v
Identify known-good VersionId
      |
      v
Retrieve version for validation
      |
      v
Validate state JSON
      |
      v
Obtain recovery approval
      |
      v
Restore only when required
      |
      v
terraform init
      |
      v
terraform plan
      |
      v
Review before apply
```

Routine recovery testing must not delete or overwrite live Terraform state.

An older state version can be retrieved to a temporary file and independently validated.

## 20. Important Design Decisions

### One shared VPC

The lab deliberately uses one shared VPC rather than separate VPCs for each environment.

### Separate Terraform states

Shared networking and each environment have independent Terraform states.

### Modules own resources

AWS resource definitions belong inside reusable modules.

Root/environment configurations compose modules and provide configuration.

### IAM policies are separate

IAM policy documents are maintained under:

```text
iam/policies/
```

### No static AWS credentials

GitHub Actions uses OIDC.

### No customer-managed KMS CMKs

AWS-managed/default encryption is used.

### No application resources in the current baseline

Application infrastructure was intentionally removed. The current focus is the enterprise Terraform foundation and shared networking.

## 21. Operating Model

Recommended change flow:

```text
Developer branch
      |
      v
Pull Request
      |
      v
Terraform CI
      |
      +-- fmt
      +-- init
      +-- validate
      +-- TFLint
      |
      v
Review / Approval
      |
      v
main
      |
      +--> Shared deployment
      |
      +--> Dev deployment
      |
      +--> Staging promotion
      |
      +--> Production promotion
```

Infrastructure managed by Terraform should be changed through Terraform rather than manually through the AWS console.

## 22. Validation Checklist

### Terraform

- [x] Terraform 1.15.0 standardized
- [x] AWS provider 6.x standardized
- [x] Shared VPC module validated
- [x] Terraform formatting validated
- [x] Terraform validation passing
- [x] TFLint passing
- [x] Separate root states
- [x] Remote S3 backend
- [x] S3 lockfile enabled

### Networking

- [x] VPC `10.20.0.0/22`
- [x] Two Availability Zones
- [x] Two public subnets
- [x] Two private subnets
- [x] One NAT Gateway
- [x] One Elastic IP
- [x] Shared networking isolated from environment application resources

### GitHub Actions

- [x] PR-based Terraform CI
- [x] Manual DEV deployment
- [x] Manual staging promotion
- [x] Manual production promotion
- [x] Manual shared deployment
- [x] Protected destroy workflow

### AWS Authentication

- [x] GitHub OIDC
- [x] Immutable repository identity
- [x] Separate IAM roles
- [x] Static AWS keys avoided
- [x] Broad temporary permissions removed
- [x] Least-privilege policies applied

### State Security

- [x] S3 versioning
- [x] Public access blocked
- [x] Bucket owner enforced
- [x] Server-side encryption
- [x] HTTPS-only policy
- [x] State lifecycle retention
- [x] State recovery procedure

### Repository Governance

- [x] Main branch protection/rules
- [x] Pull request requirement
- [x] Terraform CI status check
- [x] Deployment branch restrictions
- [x] Main-branch runtime checks

## 23. Known Intentional Scope Exclusions

The following are outside the current baseline because they are already established elsewhere or intentionally deferred:

- AWS account governance controls
- CloudTrail baseline implementation
- AWS Config baseline implementation
- IAM Access Analyzer baseline implementation
- Security Hub baseline implementation
- Preventive SCP rollout
- Application workload infrastructure
- Customer-managed KMS key architecture
- Multi-VPC environment architecture

These should only be introduced as separate, explicit phases.

## 24. Future Expansion

Potential future phases:

```text
Phase 1
Terraform foundation
    |
    +-- Remote state
    +-- Shared networking
    +-- CI
    +-- OIDC
    +-- Least privilege
    +-- Repository controls
    +-- State protection

Phase 2
Preventive controls
    |
    +-- SCPs
    +-- Additional IAM boundaries
    +-- Resource-level IAM restrictions
    +-- Policy validation

Phase 3
Application infrastructure
    |
    +-- Compute
    +-- Load balancing
    +-- Databases
    +-- Containers
    +-- Application security

Phase 4
Advanced enterprise controls
    |
    +-- Automated remediation
    +-- Drift detection
    +-- Policy-as-code
    +-- Cost controls
    +-- Compliance automation
```

## 25. Repository Principles

1. Do not change deliberate network CIDRs without an explicit architecture decision.
2. Do not recreate resources that were intentionally removed.
3. Do not mix shared and environment Terraform state.
4. Do not use static AWS credentials in GitHub Actions.
5. Do not grant environment roles access to other environment states.
6. Do not grant environment roles write access to shared state.
7. Do not introduce customer-managed KMS keys unless explicitly required.
8. Do not bypass Terraform for Terraform-managed resources without a deliberate exception.
9. Keep reusable AWS resource definitions inside modules.
10. Keep IAM policy documents separate from Terraform resource modules.
11. Require CI validation before merging Terraform changes to `main`.
12. Treat Terraform state as sensitive infrastructure data and protect it accordingly.

## 26. Current Baseline Status

The enterprise Terraform foundation is established with:

```text
                    AWS Terraform Enterprise Lab
                              |
          +-------------------+-------------------+
          |                   |                   |
       Terraform          GitHub Actions        AWS
        Foundation             CI/CD            Security
          |                   |                   |
       Remote State          OIDC             Least Privilege
       Shared VPC            Deployments      State Isolation
       State Recovery        Promotion        S3 Protection
       Reusable Module       Destroy Guard     HTTPS
                              |
                              v
                         main Protection
```

The current baseline is intentionally focused on the **Terraform platform and infrastructure delivery foundation**, with application resources and account governance excluded from this phase.
