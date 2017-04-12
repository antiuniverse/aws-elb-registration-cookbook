module AwsElbRegistration
  # TODO: Rethink configuration schema and support chef search?
  BAG_NAME = 'aws-elb-registration'
  ALB_BAG_NAME = "aws-elbv2-registration"
  BAG_ITEM_MAPPING_HOSTNAMES = 'hostname_mappings'
  BAG_ITEM_MAPPING_LAYERS = 'layer_mappings'
  WILDCARD_KEY = '_all'


  module Helpers
    def get_mapped_resources( bag_name, hostname, layers )
      hostname ||= node[:opsworks][:instance][:hostname]
      layers ||= node[:opsworks][:instance][:layers]

      mapped_resources = parse_matching_rules(
        hostname,
        data_bag_safe_item( bag_name, BAG_ITEM_MAPPING_HOSTNAMES )
      )

      mapped_resources += parse_matching_rules(
        layers,
        data_bag_safe_item( bag_name, BAG_ITEM_MAPPING_LAYERS )
      )

      return mapped_resources.uniq
    end


    # Return array of ELB names mapped to ++hostname++ and/or ++layers++.
    def get_mapped_elbs( hostname = nil, layers = nil )
      get_mapped_resources( BAG_NAME, hostname, layers )
    end

    # Return array of ELBv2 names mapped to ++hostname++ and/or ++layers++.
    def get_mapped_elbsv2( hostname = nil, layers = nil )
      get_mapped_resources( ALB_BAG_NAME, hostname, layers )
    end

    # Non-existent items return an empty hash instead of raising an exception.
    # The non-existence of the data bag itself will still raise an exception.
    def data_bag_safe_item( bag_name, item )
      if data_bag( bag_name ).include?( item )
        return data_bag_item( bag_name, item )
      else
        return {}
      end
    end

    # For each string in +needles+, check for a matching key in +haystack+.
    # If a matching key is found, split the corresponding value's comma-separated
    # list into an array. Concatenate all such arrays and return the result.
    # If ++include_wildcard++ is true, ++WILDCARD_KEY++ values are included.
    # Note: The returned array can contain duplicate values.
    def parse_matching_rules( needles, haystack, include_wildcard = true )
      needles = [*needles]

      needles.push( WILDCARD_KEY ) if include_wildcard

      matched_values = []

      needles.each do | needle |
        matched_values += haystack[needle].split( /\s*,\s*/ ) if haystack.key?( needle )
      end

      return matched_values
    end
  end
end
