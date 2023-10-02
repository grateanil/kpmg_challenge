variable "access_key" {
        default = ""
}
variable "secret_key" {
        default = ""
}
variable "region" {
        default = "us-east-1"
}

variable "key_name" {
        description = "Name of my AWS key pair"
        default = "my_key"
        #default = "anilraut"
}

variable "public_key_path" {
        description = "Path to my public key"
        type    = string
        default = "/f/Devops/terraform/.ssh/id_rsa.pub"
        #default = "./id_rsa.pub"
        #default = "/f/Devops/terraform/KPMG/challenge1/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to my private key"      
  type    = string
  default = "/f/Devops/terraform/anilraut.pem"
  #default = "./anilraut.pem"
  #default = "/f/Devops/terraform/KPMG/challenge1/anilraut.pem"
}

variable "amis" {
        type = map
default = {
        ap-south-1 = "ami-f9daac96"
        us-east-1 = "ami-f973ab84"
        us-west-2 = "ami-06b94666"
        }
}
