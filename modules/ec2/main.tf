locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )

  default_user_data = <<-EOT
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd

    cat <<EOF > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
      <head>
        <title>${local.name_prefix}</title>
      </head>
      <body>
        <h1>Terraform Multi-Environment Project</h1>
        <p>Environment: ${var.environment}</p>
        <p>Managed by Terraform</p>
      </body>
    </html>
    EOF
  EOT
}

data "aws_ami" "amazon_linux" {
  count = var.create_instance && var.ami_id == null ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  count = var.create_instance ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  count = var.create_instance ? 1 : 0

  name               = "${local.name_prefix}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role[0].json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count = var.create_instance ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance ? 1 : 0

  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.this[0].name

  tags = local.common_tags
}

resource "aws_security_group" "this" {
  count = var.create_instance ? 1 : 0

  name        = "${local.name_prefix}-ec2-sg"
  description = "Security group for the ${local.name_prefix} EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_ingress_cidrs
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2-sg"
    }
  )
}

resource "aws_instance" "this" {
  count = var.create_instance ? 1 : 0

  ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux[0].id

  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this[0].id]
  iam_instance_profile        = aws_iam_instance_profile.this[0].name
  associate_public_ip_address = var.associate_public_ip_address

  user_data = var.user_data != null ? var.user_data : local.default_user_data

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]
}