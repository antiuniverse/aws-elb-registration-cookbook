#
# Cookbook Name:: aws-elb-registration
# Recipe:: register
#
# Copyright (C) 2015 Zach Brockway
# All rights reserved - See LICENSE for details
#
# h/t Richard Hurt (http://kangaroobox.blogspot.co.nz/2013/03/integrating-elb-into-opsworks-stack.html)

include_recipe 'awscli'


my_instance_id = node[:opsworks][:instance][:aws_instance_id]
my_hostname = node[:opsworks][:instance][:hostname]

elb_maps = data_bag_item( "aws-elb-registration", "hostnames_to_balancers_map" )

Chef::Log.info( "aws-elb-registration::register - #{elb_maps.to_json}" )

elb_names = []
elb_names += elb_maps["_all"].split( /,\s*/ ) if elb_maps.has_key?( "_all" )
elb_names += elb_maps[my_hostname].split( /,\s*/ ) if elb_maps.has_key?( my_hostname )
elb_names.uniq!

Chef::Log.info( "aws-elb-registration::register - Registering #{my_hostname} with #{elb_names}" )

elb_names.each do | elb_name |
  execute "register_with_#{elb_name}" do
    # http://docs.aws.amazon.com/cli/latest/reference/elb/register-instances-with-load-balancer.html
    command "aws "\
      "--region #{node[:opsworks][:instance][:region]} "\
      "elb register-instances-with-load-balancer "\
      "--load-balancer-name #{elb_name} "\
      "--instances #{my_instance_id}"
  end
end