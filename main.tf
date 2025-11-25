resource "aws_launch_template" "web_server_as" {
    name = "srbproject"
    image_id = "ami-0fa3fe0fa7920f68e"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t3.micro"
    key_name = "MAINKEY"
    tags = {
        Name = "SRBDevOps"
    }
    
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-076099e8d25a81c56", "subnet-0c294ced08292590c"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-east-1a", "us-east-1b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

