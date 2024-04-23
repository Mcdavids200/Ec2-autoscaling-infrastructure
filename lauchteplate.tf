resource "aws_launch_template" "apache-template" {
  name = "apache-template"

  vpc_security_group_ids = [aws_security_group.allow-lb.id]
  image_id = var.ami

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "apache-autoscaling-lauch-template"
    }
  }
    instance_type = "t2.micro"

  user_data = filebase64("apachescript/apachescript.sh")
}




