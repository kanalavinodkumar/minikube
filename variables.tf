variable "project_name" {
  default = "Minikube"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  type = map
  default = {
    Name = "Minikube"
    Terraform = "true"
    Environment = "DEV"
  }
}

variable "public_subnet_cidr" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

# variable "private_subnet_cidr" {
#   default = ["10.0.11.0/24","10.0.12.0/24"]
# }

# variable "database_subnet_cidr" {
#   default = ["10.0.21.0/24","10.0.22.0/24"]
# }

variable "key_name" {
  default = "kubernetes"
}

variable "key_location" {
  default = "K:/Devops/Practice/minikube/provisioners.pub"
}



variable "hosted_zone" {
  default = "vinodhub.online"
}

variable "ingress" {
  type = map
  default = {
    
    postgress = {
    description      = "Allow 443 port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    http = {
    description      = "Allow 80 port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    Jenkins = {
    description      = "Allow 8080 port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    ssh = {
    description      = "Allow 22 port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  
}
variable "subnet_cidr" {
  type = string
  default = "10.0.1.0/24"
}