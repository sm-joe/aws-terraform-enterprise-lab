# Terraform State Recovery Procedure

## Scope

This procedure applies to the Terraform state stored in the centralized
Amazon S3 state bucket.

## Protection

Terraform state is protected by:

- S3 versioning
- S3 public access blocking
- Bucket owner enforced ownership
- Server-side encryption
- HTTPS-only bucket access
- S3 lifecycle retention of noncurrent versions

## Recovery Procedure

1. Identify the affected Terraform state object.
2. List available S3 object versions.
3. Identify the required known-good VersionId.
4. Retrieve the selected version for validation.
5. Validate the recovered state JSON.
6. Confirm the VersionId and recovery target with the infrastructure owner.
7. Restore the selected version only after approval.
8. Run `terraform init`.
9. Run `terraform plan`.
10. Review the plan carefully before any apply operation.

## Recovery Validation

Never overwrite the live state as part of a routine recovery test.

A recovery test should retrieve an older S3 version to a temporary location
and validate that the state is readable JSON.

## Important

Terraform state recovery must not be performed by simply deleting the current
state object.

S3 versioning must be used to preserve and recover historical state versions.
