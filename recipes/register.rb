#
# Cookbook Name:: aws-elb-registration
# Recipe:: register
#
# Copyright (C) 2015 Zach Brockway
# All rights reserved - See LICENSE for details
#
# h/t Richard Hurt (http://kangaroobox.blogspot.co.nz/2013/03/integrating-elb-into-opsworks-stack.html)

include_recipe 'awscli'
::Chef::Recipe.send( :include, AwsElbRegistration::Helpers )


mapped_elbs = get_mapped_elbs
mapped_elbsv2 = get_mapped_elbsv2

Chef::Log.info( "aws-elb-registration::register - Registering with #{mapped_elbs}" )
Chef::Log.info( "aws-elb-registration::register - Registering with #{get_mapped_elbsv2}" )

mapped_elbs.each do | elb_name |
  execute "register_with_#{elb_name}" do
    # http://docs.aws.amazon.com/cli/latest/reference/elb/register-instances-with-load-balancer.html

    cmd = node['awscli']['binary'].dup

    cmd << " "\
      "--region #{node[:opsworks][:instance][:region]} "\
      "elb register-instances-with-load-balancer "\
      "--load-balancer-name #{elb_name} "\
      "--instances #{node[:opsworks][:instance][:aws_instance_id]}"

    command cmd
  end
end

mapped_elbsv2.each do | target_group_arn |
  execute "register_with_#{target_group_arn}" do
    # http://docs.aws.amazon.com/cli/latest/reference/elbv2/register-targets.html

    cmd = node['awscli']['binary'].dup

    cmd << " "\
      "--region #{node[:opsworks][:instance][:region]} "\
      "elbv2 register-targets "\
      "--target-group-arn #{target_group_arn} "\
      "--targets Id=#{node[:opsworks][:instance][:aws_instance_id]}"

    command cmd
  end
end
