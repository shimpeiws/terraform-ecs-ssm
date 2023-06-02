variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "image_uri" {
  description = "Docker Image URI"
  type        = string
}

variable "desired_task_count" {
  description = "ECS Service Desired Task Count"
  type        = number
}

variable "iam_role_arn" {
  description = "IAM role arn"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "subnet_public_0" {
  description = "Subnet Public0 ID"
  type        = string
}

variable "subnet_private_0" {
  description = "Subnet Private0 ID"
  type        = string
}

variable "subnet_private_1" {
  description = "Subnet Private1 ID"
  type        = string
}
