## provider aws
provider "aws" {
        access_key = "${var.access_key}"
        secret_key = "${var.secret_key}"
        region = "${var.region}"
 }

## create vpc
resource "aws_vpc" "my_vpc" {
        cidr_block = "192.168.0.0/16"
 }

 
## create internet gateway
resource "aws_internet_gateway" "my_igw" {
        vpc_id = "${aws_vpc.my_vpc.id}"
 }

## create route table entry
resource "aws_route" "internet_access" {
        route_table_id = "${aws_vpc.my_vpc.main_route_table_id}"
        destination_cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my_igw.id}"
 }

 
## create subnet
resource "aws_subnet" "my_sub" {
        vpc_id = "${aws_vpc.my_vpc.id}"
        cidr_block = "192.168.1.0/24"
        map_public_ip_on_launch = "true"
 }

 
## create security group and associate with vpc
resource "aws_security_group" "elb_sg" {
        name = "my.elb.sg"
        vpc_id = "${aws_vpc.my_vpc.id}"
        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                }
        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                }
}

resource "aws_security_group" "ec2_sg" {
        name = "my.ec2.sg"
        vpc_id = "${aws_vpc.my_vpc.id}"
        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                }
        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["192.168.0.0/16"]
                }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                }
}

resource "aws_elb" "my_elb" {
        name = "my-web"
        subnets = ["${aws_subnet.my_sub.id}"]
        security_groups = ["${aws_security_group.elb_sg.id}"]
        instances = ["${aws_instance.my_instance.id}"]
        connection_draining = "true"
        listener {
                instance_port = 80
                instance_protocol = "http"
                lb_port = 80
                lb_protocol = "http"
                }

        health_check {
                healthy_threshold = 2
                unhealthy_threshold = 2
                timeout = 3
                target = "HTTP:80/"
                interval = 30
                }
        }

resource "aws_key_pair" "auth" {
        key_name = "${var.key_name}"
        public_key = file("${path.module}/id_rsa.pub")
}

# EC2 instance with nginx web server installed using remote exec provisioner
resource "aws_instance" "my_instance" {
        connection {
                type = "ssh"
                user = "ec2-user"
                private_key = file("${path.module}/anilraut.pem")
                #private_key = file(var.private_key_path)
                host        = self.public_ip
                timeout = "3m"
                agent = false
                   }
        instance_type = "t2.micro"
        ami = "${lookup(var.amis, var.region)}"
        key_name = "${aws_key_pair.auth.id}"
        #vpc_security_group_ids = ["aws_security_group.ec2_sg.id"]
        subnet_id = aws_subnet.my_sub.id
        provisioner "remote-exec" {
                        inline = [
                                  "sudo yum install nginx -y",
                                  "sudo service nginx start",
                                  ]

                                }
}

