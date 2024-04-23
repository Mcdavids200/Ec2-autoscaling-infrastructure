#create-autoscaling group

resource "aws_autoscaling_group" "autoscale" {
  name                      = "apache-autoscale"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id, aws_subnet.private-subnet-c.id]
  launch_template {
    id      = aws_launch_template.apache-template.id
    version = "$Latest"
  }
  target_group_arns    = [aws_lb_target_group.apache-targetgroup.arn]
  termination_policies = ["OldestLaunchTemplate"]


}



#creat scaling policy

resource "aws_autoscaling_policy" "apache_policy_up" {
    name = "apache_policy_up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.autoscale.name
  
}
resource "aws_cloudwatch_metric_alarm" "apache_cpu_alarm_up" {
  alarm_name                = "apache_cpu_alarm_up"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 60
  alarm_description         = "This metric monitors ec2 cpu utilization when it scales up"
  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.autoscale.name
  }
}




resource "aws_autoscaling_policy" "apache_policy_down" {
    name = "apache_policy_down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.autoscale.name
  
}
resource "aws_cloudwatch_metric_alarm" "apache_cpu_alarm_down" {
  alarm_name                = "apache_cpu_alarm_down"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "This metric monitors ec2 cpu utilization when it scales down"
  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.autoscale.name
  }
}
