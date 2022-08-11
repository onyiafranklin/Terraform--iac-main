terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}
/*=============LOAD BALANCER SECURITY GROUP===============================*/
resource "aws_security_group" "LBSG" {
    name        = "allow_tls"
    description = "Allow TLS inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        description      = "TLS from VPC"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_name}-lb-sg"
    }
}
/*====================================LOAD BALANCER======================================*/
resource "aws_lb" "WebAppLB" {
    name                       = "${var.env_name}-lb"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            = [aws_security_group.LBSG.id]
    drop_invalid_header_fields = true
    subnets                    = [var.pub_subnet_1, var.pub_subnet_2]

  tags = {
    Name = "${var.env_name}-lb"
  }
}
/*=============================LOAD BALANCER LISTENER================================================*/
resource "aws_lb_listener" "Listener" {
    load_balancer_arn = aws_lb.WebAppLB.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.WebAppTargetGroup.arn
    }
}

resource "aws_lb_listener_rule" "ALBListenerRule" {
  listener_arn = aws_lb_listener.Listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebAppTargetGroup.arn
  }

  condition {
    path_pattern {
        values = [ "/" ]
    }
  }
}

resource "aws_lb_target_group" "WebAppTargetGroup" {
    name        = "${var.env_name}-lb-tg"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    health_check {
      healthy_threshold   = 2
      interval            = 10
      matcher             = 200
      path                = "/"
      unhealthy_threshold = 5
    }
}
resource "aws_security_group" "WebServerSG" {
    name        = "${var.env_name}-instance-sg"
    description = "Allow TLS inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        description      = "TLS from LB"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = -1
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_name}-instance-sg"
    }
}

resource "aws_launch_configuration" "WebAppLaunchConfig" {
    image_id        = var.ami
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.WebServerSG.id]
    user_data       = <<-EOF
                      #!/bin/bash
                      sudo apt-get update -y
                      sudo apt-get install apache2 -y
                      sudo systemctl start apache2
                      cd /var/www/html
                      echo "Udacity Demo Web Server Up and Running!" > index.html
                      EOF
    ebs_block_device {
        device_name = "/dev/sdk"
        volume_size = 10
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "WebAppGroup" {
    name                      = "${var.env_name}-asg"
    max_size                  = 6
    min_size                  = 4
    launch_configuration      = aws_launch_configuration.WebAppLaunchConfig.name
    health_check_grace_period = 120
    health_check_type         = "ELB"
    vpc_zone_identifier       = [var.prv_subnet_1, var.prv_subnet_2]
    target_group_arns         = [aws_lb_target_group.WebAppTargetGroup.arn]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_attachment" "WebAppGroupAttachment" {
    autoscaling_group_name = aws_autoscaling_group.WebAppGroup.id
    alb_target_group_arn   = aws_lb_target_group.WebAppTargetGroup.arn
}