# ------------------
# General
# ------------------
location    = "koreacentral"
prefix      = "econ"
environment = "krcuat"
tags        = { "environment" = "krcuat", "managedBy" = "terraform" }

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
  isenabled = false
  configs = [ "" ]
}

archive = {
  isenabled = false
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