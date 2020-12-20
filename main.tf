provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}
)

# AMI com AWS Linux
resource "aws_instance" "live" {
    ami 		= "ami-04152c3a27c49a944"
  	instance_type	= "t2.micro"


# AMI com CentOS 7
resource "aws_instance" "live" {
    ami 		= "ami-01e36b7901e884a10"
  	instance_type	= "t2.micro"
}

resource null_resource "teste" {
  depends_on = [
    "aws_instance.live"
]

provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key '${var.aws_pem_location}' -i '${aws_instance.live.public_ip}' main.yml"
  }

}

resource "aws_security_group" "ssh-group" {
  name = "ssh-access-group"
  description = "Allow traffic to port 22 (SSH)"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
