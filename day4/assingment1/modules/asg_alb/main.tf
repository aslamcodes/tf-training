resource "aws_lb" "alb" {
  name               = "aslam-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets[*].id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  name     = "aslam-tg"


  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = "200"
  }

  tags = {
    Name = "aslam-tg"
  }
}

resource "aws_autoscaling_group" "asg" {
  name             = "aslam-asg"
  max_size         = 4
  min_size         = 1
  desired_capacity = 3

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets[*].id

  target_group_arns = [aws_lb_target_group.tg.arn]
}

resource "aws_launch_template" "lt" {
  image_id               = "ami-06b21ccaeff8cd686"
  instance_type          = "t2.medium"
  key_name               = "aslamtask"
  vpc_security_group_ids = [aws_security_group.server_sg.id]


  user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Wanna have a cup of coffee" | sudo tee /var/www/html/index.html
                EOF
  )
}
