# ------------------
# General
# ------------------
variable "location" {
  type        = string
  description = "Location/Region that will be used for resources"
}

variable "prefix" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "environment" {
  type        = string
  description = "The environment name that will be used for tagging"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Any tags that should be present on the resources"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    "environment"              = "PROD"
    "managedBy"                = "Terraform"
    "mbmTechnicalOwnerContact" = "ajai.sreenilayam@mercedes-benz.com"
  }
}

# eCon Apps Vars

variable "esign" {
  type = object({
    isenabled = bool
    configs = list(string)
  })
  default = {
    isenabled   = true
    string_list = [""]
  }
}

variable "archive" {
  type = object({
    isenabled = bool
    configs = list(string)
  })
  default = {
    isenabled   = true
    string_list = [""]
  }
}

variable "camunda" {
  type = object({
    isenabled = bool
    configs = list(string)
  })
  default = {
    isenabled   = true
    string_list = [""]
  }
}

variable "appworks" {
  type = object({
    isenabled = bool
    configs = list(string)
  })
  default = {
    isenabled   = true
    string_list = [""]
  }
}

variable "docgen" {
  type = object({
    isenabled = bool
    configs = list(string)
  })
  default = {
    isenabled   = true
    string_list = [""]
  }
}

variable "ocr" {
  type = object({
    isenabled = bool
    configs = list(string)
  })
  default = {
    isenabled   = true
    string_list = [""]
  }
}