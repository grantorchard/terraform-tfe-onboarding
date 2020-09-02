/*output azure_enabled_workspace_ids {
  value = for k,v [
    module.*.workspace_id
  ]
}*/
output groups {
  value = toset(flatten([ for v in module.workspace_onboarding: v.groups ]))
}