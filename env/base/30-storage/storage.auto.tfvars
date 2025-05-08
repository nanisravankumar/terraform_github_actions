# ------------------
# General
# ------------------
location    = "westeurope"
prefix      = "econ"
environment = "prod"
tags        = { "environment" = "prod", "managedBy" = "terraform" }

# eCon Apps
esign = {
  isenabled = true
  configs = [ "" ]
}

camunda = {
  isenabled = true
  configs = [ "" ]
}

appworks = {
  isenabled = true
  configs = [ "" ]
}

archive = {
  isenabled = true
  configs = [ "" ]
}

docgen = {
  isenabled = true
  configs = [ "" ]
}

ocr = {
  isenabled = true
  configs = [ "" ]
}