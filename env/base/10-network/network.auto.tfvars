# ------------------
# General
# ------------------
location    = "westeurope"
prefix      = "econ"
environment = "prod"
hasACR      = true
tags        = { "environment" = "prod", "managedBy" = "terraform" }
rgtags      = {
  "mbmAppName"               = "eConCloud"
  "mbmCloudSecResponsible"   = "Sr@gmail.com"
  "mbmEnvironment"           = "NONPRD"
  "mbmInformationOwner"      = "sr@gmail.com"
  "mbmIso"                   = "sr@gmail.com"
  "mbmPlanningItId"          = "APP-32072"
  "mbmProductiveData"        = "yes"
  "mbmTechnicalOwner"        = "srs@gmail.com"
  "mbmTechnicalOwnerContact" = "sr@gmail.com"
  "mbmConfidentiality"       = "confidential"
  "mbmIntegrity"             = "critical"
  "mbmAvailability"          = "critical"
  "mbmPersonalData"          = "yes"
  "mbmContinuityCritical"    = "yes"
  "managedBy"                = "terraform"
}