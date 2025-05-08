variable "tags" {
  type        = any
  description = "List of storage account tags"
}
variable "location" {
  description = "Location"
}
variable "prefix" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}
variable "environment" {
  type        = string
  description = "The environment name that will be used for tagging"
}