variable subscription_id {
  type    = map(string)
  default = {
    production  = "14692f20-9428-451b-8298-102ed4e39c2a"
    development = ""
    staging     = ""
    test        = ""
  }
}

variable environment {
  type    = string
  default = "production"
}
