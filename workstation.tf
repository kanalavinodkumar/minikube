resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.common_tags
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = var.common_tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = var.common_tags
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = var.common_tags
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#SG
resource "aws_security_group" "sg" {
  name = "workstation-SG"
  description = "SG"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = var.common_tags
}

resource "aws_key_pair" "kubernetes" {
  key_name   = var.key_name
  public_key = file(var.key_location)
}

resource "aws_instance" "workstation" {
    #this is fetching AWS Linux 2 AMI ID dynamically
    ami = data.aws_ami.ami_id.id
    # from instance_type map instance will be selected based on the current workspace
    instance_type = "t3.small"
    root_block_device  {
      volume_size = 20
    }
    key_name = aws_key_pair.kubernetes.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = "${file("scripts/docker.sh")}"
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    tags = {
        Name = "workstation"
    }
}