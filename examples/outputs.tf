/*output azure_enabled_workspace_ids {
  value = for k,v [
    module.*.workspace_id
  ]
}*/