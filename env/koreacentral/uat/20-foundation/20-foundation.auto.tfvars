# ------------------
# General
# ------------------
location      = "koreacentral"
prefix        = "econ"
environment   = "krcuat"
locationshort = "krc"
tags          = { "environment" = "krcuat", "managedBy" = "terraform" }
common_tags   = { "environment" = "krcuat", "managedBy" = "terraform", "mbmTechnicalOwnerContact" = "sr@gm.com" }
hasACR        = false
#-------- AKV Parameters --------#
keyvault = [
  {
    key_vault_name                     = "ocr"
    enable_diagnostic_monitor_settings = true
    access_policy = [
      {
        object_id               = "7f037f80-1551-4af8-99f2-d8c891a41e87" #CGT_g_econcloud-OCR-Admin-Non-Prod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "4e4f4b74-a28f-4b7b-90d3-544876a2dd36" #DAI-GB4_ECONTRACTING-SANDBOX_AKS-TERRAFORMER_618-1
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "59fb8f2d-266e-46e6-ad56-101407c608e1" #CGT_g_econ-Cloudinfra-team-nonprod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      }
    ]
  },
  {
    key_vault_name                     = "camund"
    enable_diagnostic_monitor_settings = true
    access_policy = [
      {
        object_id               = "51ff69e3-cfb0-41f2-878c-25dc41529fcf" #CGT_g_econcloud-Camunda-Admin-Non-prod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "4e4f4b74-a28f-4b7b-90d3-544876a2dd36" #DAI-GB4_ECONTRACTING-SANDBOX_AKS-TERRAFORMER_618-1
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "59fb8f2d-266e-46e6-ad56-101407c608e1" #CGT_g_econ-Cloudinfra-team-nonprod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      }
    ]
  },
  {
    key_vault_name                     = "docgen"
    enable_diagnostic_monitor_settings = true
    access_policy = [
      {
        object_id               = "6e8c5bbb-e934-44ee-a62f-2a30cccf31c2" #CGT_g_econcloud-DOCGEN-Admin-Non-PROD
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "4e4f4b74-a28f-4b7b-90d3-544876a2dd36" #DAI-GB4_ECONTRACTING-SANDBOX_AKS-TERRAFORMER_618-1
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "59fb8f2d-266e-46e6-ad56-101407c608e1" #CGT_g_econ-Cloudinfra-team-nonprod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      }
    ]
  },
  {
    key_vault_name                     = "esign"
    enable_diagnostic_monitor_settings = true
    access_policy = [
      {
        object_id               = "def8d5e6-ec96-4191-bfce-3fb5bbb91bdc" #CGT_g_econcloud-Esign-Admin-Non-Prod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "4e4f4b74-a28f-4b7b-90d3-544876a2dd36" #DAI-GB4_ECONTRACTING-SANDBOX_AKS-TERRAFORMER_618-1
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      },
      {
        object_id               = "59fb8f2d-266e-46e6-ad56-101407c608e1" #CGT_g_econ-Cloudinfra-team-nonprod
        key_permissions         = ["Get", "Backup", "Create", "Decrypt", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Encrypt", "Decrypt", "Sign", "Verify"]
        secret_permissions      = ["Get", "Set", "Backup", "Delete", "List", "Purge", "Recover", "Restore"]
        certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "SetIssuers", "Update"]
        storage_permissions     = ["Get", "Backup", "Delete", "DeleteSAS", "GetSAS", "List"]
      }
    ]
  }
]
#-------- AKV Parameters --------#