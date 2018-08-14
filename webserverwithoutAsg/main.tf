resource "aws_instance" "firstMachine"
{
 ami= "ami-ba602bc2"
 instance_type = "t2.micro"
 vpc_security_group_ids = ["${aws_security_group.terraformAccess.id}"]

 user_data =<<-EOF
        #! /bin/bash
        echo "Hello World" > index.html
        nohup busybox httpd -f -p "${var.server_port}" &
        EOF

 tags {
	Name = "Terraform-testMachine"
}

}

resource "aws_security_group" "terraformAccess"
{
	name= "Terraform example access"
	ingress {
 		  from_port = "${var.server_port}"
   		  to_port   = "${var.server_port}"
                  protocol  = "tcp"
                  cidr_blocks = ["0.0.0.0/0"]

		}
	ingress {
		  from_port = 22
                  to_port   = 22
                  protocol  = "tcp"
                  cidr_blocks =["0.0.0.0/0"]
		}
}

variable "server_port"
{
 	 description = "The port of server on which server listen"
  	default = 8080
}

output "ipaddress"
{
	value = "${aws_instance.firstMachine.public_ip}"
}
