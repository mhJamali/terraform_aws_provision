output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = [aws_subnet.public_subnet.*.id]
}

output "private_subnets_id" {
  value = [aws_subnet.private_subnet.*.id]
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "security_groups_ids" {
  value = [aws_security_group.default.id]
}

output "public_route_table" {
  value = aws_route_table.public.id
}

/* elb output */
output "elb-dns-name" {
  value = aws_elb.terra-elb.dns_name
}

/* autoscaling configuration outputs */

output "this_launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = module.autoscaling.this_launch_configuration_id
}

output "this_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.autoscaling.this_autoscaling_group_id
}

output "this_autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = module.autoscaling.this_autoscaling_group_availability_zones
}

output "this_autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = module.autoscaling.this_autoscaling_group_vpc_zone_identifier
}

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.autoscaling.this_autoscaling_group_load_balancers
}

output "this_autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = module.autoscaling.this_autoscaling_group_target_group_arns
}
