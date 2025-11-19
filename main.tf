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

# --------------------------
#   SECURITY GROUP FOR ALB
# --------------------------
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}

# --------------------------
#   APPLICATION LOAD BALANCER
# --------------------------
resource "aws_lb" "application_lb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.lb_subnets

  tags = {
    Name = "My-ALB"
  }
}

# --------------------------
#   TARGET GROUP
# --------------------------
resource "aws_lb_target_group" "alb_tg" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

# --------------------------
#   REGISTER EC2 WITH ALB
# --------------------------
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.example.id
  port             = 80
}

# --------------------------
#   LISTENER (ALLOW HTTP)
# --------------------------
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
