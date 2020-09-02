output "groups" {
  value = toset([
    for v in azuread_group.users: {
      "name" = v.name,
      "description" = v.description
    }
  ])
}
