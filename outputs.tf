output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "ebs_volume_id" {
  description = "ID of the EBS volume"
  value       = aws_ebs_volume.example_volume.id
}

output "attached_device_name" {
  description = "Device name used to attach the EBS volume"
  value       = aws_volume_attachment.example_attach.device_name
}
