variable "name" {
  description = "Name identifier for the RDS instance."
  type        = string
}

variable "identifier" {
  description = "Unique RDS instance identifier."
  type        = string
}

variable "engine" {
  description = "Database engine."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "17"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "RDS storage type."
  type        = string
  default     = "gp3"
}

variable "database_name" {
  description = "Initial database name."
  type        = string
}

variable "master_username" {
  description = "Master database username."
  type        = string
  default     = "labadmin"
}

variable "master_password" {
  description = "Master database password."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port."
  type        = number
  default     = 5432
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnets are required for the DB subnet group."
  }
}

variable "security_group_ids" {
  description = "Security groups attached to the RDS instance."
  type        = list(string)
}

variable "multi_az" {
  description = "Whether to deploy the database as Multi-AZ."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 0
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the database."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Whether to prevent accidental database deletion."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for RDS resources."
  type        = map(string)
  default     = {}
}
