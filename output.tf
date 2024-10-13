output "resource_group_id" {
  value = module.resource_group.id
}

output "id" {
  value = { for k, v in module.vm : k => v.vm_id }
}

output "vm_private_ips" {
  value = { for k, v in module.vm : k => v.private_ip }
}