resource "aws_instance" "example" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key
  associate_public_ip_address = true

  tags = {
    Name = "AWS-instance"
  }
}

resource "aws_ebs_volume" "example_volume" {
  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
}

resource "aws_volume_attachment" "example_attach" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.example_volume.id
  instance_id = aws_instance.example.id

  depends_on = [
    aws_instance.example,
    aws_ebs_volume.example_volume
  ]
}