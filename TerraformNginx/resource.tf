resource "tls_private_key" "this" {
  algorithm = "RSA"
}
resource "aws_key_pair" "tftest"{
    key_name= "testTF"
    public_key= "${tls_private_key.this.public_key_openssh}"
}
data "aws_launch_configuration" "as_conf" {
  name = "webServerBehindNginx"
}
resource "aws_security_group" "sg_launchConfig"{
    name = "sgLaunchConfig"
    ingress{
        from_port= 80
        to_port= 80
        protocol= "tcp"
        cidr_blocks= ["49.207.207.40/32"]
    }
    egress{
        from_port= 0
        to_port= 0
        protocol= "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }
}

resource "aws_autoscaling_group" "asg"{
    name= "webServer"
    availability_zones = ["ap-south-1a"]
    desired_capacity= 2
    min_size= 1
    max_size= 2
    health_check_type= "EC2"
    launch_configuration= "${data.aws_launch_configuration.as_conf.name}"
}