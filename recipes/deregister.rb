#
# Cookbook Name:: aws-elb-registration
# Recipe:: deregister
#
# Copyright (C) 2015 Zach Brockway
# All rights reserved - See LICENSE for details
#
# h/t Richard Hurt (http://kangaroobox.blogspot.co.nz/2013/03/integrating-elb-into-opsworks-stack.html)

include_recipe 'awscli'
::Chef::Recipe.send( :include, AwsElbRegistration::Helpers )


mapped_elbs = get_mapped_elbs

Chef::Log.info( "aws-elb-registration::deregister - Deregistering from #{mapped_elbs}" )

mapped_elbs.each do | elb_name |
  execute "deregister_from_#{elb_name}" do
    # http://docs.aws.amazon.com/cli/latest/reference/elb/deregister-instances-from-load-balancer.html

    cmd = node['awscli']['binary'].dup

    cmd << " "\
      "--region #{node[:opsworks][:instance][:region]} "\
      "elb deregister-instances-from-load-balancer "\
      "--load-balancer-name #{elb_name} "\
      "--instances #{node[:opsworks][:instance][:aws_instance_id]}"

    command cmd
  end
end
