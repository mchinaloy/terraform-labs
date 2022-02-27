output "instance_ids" {
    value = aws_instance.servers[*].id
}

output "instance_public_ids" {
    value = aws_instance.servers[*].public_ip
}

output "iam_users_arn" {
    value = aws_iam_user.users[*].arn
}

output "bastion_public_ip" {
    value = var.create_bastion == "YES" ? aws_instance.bastion[0].public_ip : null
}
