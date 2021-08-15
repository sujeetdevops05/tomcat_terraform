provider "aws" {
  region = "ap-southeast-1"
  access_key = "AKIA3V7OTMU46DIO2MGM"
  secret_key = "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"
}

resource "aws_launch_template" "asg-instance" {
  name_prefix   = "asginstance"
  image_id      = "ami-063305c160fcd6e98"
  instance_type = "t2.micro"
  
   tags = {
    Name = "tomcat-terraform-elb"
  }
  
}

resource "aws_autoscaling_group" "asg-group" {
  availability_zones = ["ap-southeast-1b"]
  desired_capacity   = 3
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.asg-instance.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_group" {
 autoscaling_group_name = aws_autoscaling_group.asg-group.id
  elb                    = aws_elb.elb-asg.id
}



resource "aws_elb" "elb-asg" {
  name               = "asg-terraform-elb"
  availability_zones = ["ap-southeast-1b"]

 # access_logs {
 #  bucket        = "foo"
 #  bucket_prefix = "bar"
 #   interval      = 60
 # }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

 #  listener {
 #   instance_port      = 8000
 #   instance_protocol  = "http"
 #   lb_port            = 443
 #   lb_protocol        = "https"
 #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
 # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  #instances                   = [aws_launch_template.asg-instance.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "tomcat-terraform-elb"
  }
}