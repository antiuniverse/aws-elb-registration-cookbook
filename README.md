# aws-elb-registration-cookbook

Provides recipes to trigger AWS instance registration with (or deregistration from) one or more Elastic Load Balancers. These can be attached to, for example, the Setup/Shutdown lifecycle events in OpsWorks.

## Supported Platforms

Tested on Amazon Linux and Ubuntu 14.04; probably works elsewhere, let me know.

## Usage

### Data Bag Configuration

`[:aws-elb-registration][:hostname_mappings]`: A hash of key/value string pairs, where each key corresponds to an OpsWorks hostname, and the value specifies a comma-separated list of names of Elastic Load Balancers with which that instance should be registered.

`[:aws-elb-registration][:layer_mappings]`: Like `hostname_mappings`, except the keys correspond to OpsWorks layer names rather than hostnames.

The special "\_all" key specifies ELBs that ALL instances should register with, and for the sake of convenience is supported in both the hostname and layer mapping directives. The result for a given instance is the union of: 1) all "\_all" ELBs, and 2) all ELBs mapped by matching hostname/layer rules.

### Example:

```json
{
  "opsworks": {
    "data_bags": {
      "aws-elb-registration": {
        "hostname_mappings": {
          "_all": "entire-stack-elb",
          "aphrodite": "greek-elb, names-starting-with-a-elb",
          "apollo": "greek-elb, names-starting-with-a-elb",
          "dionysus": "greek-elb"
        },
        "layer_mappings": {
          "_all": "also-entire-stack-elb",
          "rails": "api_elb, web_elb"
        }
      }
    }
  }
}
```

**NOTE**: The AWS CLI will assume the instance IAM role, which by default is `aws-opsworks-ec2-role`, and by default, that role does not have the permissions required to perform ELB (de)registration. A minimal policy that would allow the required operations is as follows:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "(...)",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

## License and Authors

Author:: Zach Brockway (neverender@gmail.com)

```
Copyright 2015 Zach Brockway

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
