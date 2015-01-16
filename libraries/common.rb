module AwsElbRegistration
  BAG_NAME = 'aws-elb-registration'
  WILDCARD_KEY = '_all'

  module Helpers
    def get_mapped_elbs( hostname = node[:opsworks][:instance][:hostname], layers = node[:opsworks][:instance][:layers] )
      hostname_mappings = data_bag_item( BAG_NAME, 'hostname_mappings' )
      layer_mappings = data_bag_item( BAG_NAME, 'layer_mappings' )

      mapped_elbs = []

      # Hostname mappings
      mapped_elbs += hostname_mappings[WILDCARD_KEY].split( /\s*,\s*/ ) if hostname_mappings.key?( WILDCARD_KEY )
      mapped_elbs += hostname_mappings[hostname].split( /\s*,\s*/ ) if hostname_mappings.key?( hostname )

      # Layer mappings
      mapped_elbs += layer_mappings[WILDCARD_KEY].split( /\s*,\s*/ ) if layer_mappings.key?( WILDCARD_KEY )
      layers.each do | layer_name |
        mapped_elbs += layer_mappings[layer_name].split( /\s*,\s*/ ) if layer_mappings.key?( layer_name )
      end

      return mapped_elbs.uniq
    end
  end
end
