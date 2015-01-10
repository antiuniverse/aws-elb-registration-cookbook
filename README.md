# aws-elb-registration-cookbook

Provides recipes to trigger AWS instance registration with (or deregistration from) one or more Elastic Load Balancers. These can be attached to, for example, the Configure/Shutdown lifecycle events in OpsWorks.

## Supported Platforms

TODO: List your supported platforms.

## Usage

Configured via `[:aws-elb-registration][:hostnames_to_balancers_map]`: A hash of key/value string pairs, where each key corresponds to an OpsWorks hostname, and the value represents a comma-separated list of names of Elastic Load Balancers with which that instance should be registered.

The special "\_all" key specifies ELBs that ALL instances should register with, regardless of hostname. When used in conjunction with hostname-specific entries, the result for a given host is the union of all "\_all" ELBs AND all ELBs specific to that host.

### Example:

```json
{
  "opsworks": {
    "data_bags": {
      "aws-elb-registration": {
        "hostnames_to_balancers_map": {
          "_all": "entire-stack-elb",
          "aphrodite": "greek-elb, names-starting-with-a-elb",
          "apollo": "greek-elb, names-starting-with-a-elb",
          "dionysus": "greek-elb"
        }
      }
    }
  }
}
```

**NOTE**: By default, the AWS CLI will assume the IAM role `aws-opsworks-ec2-role`, and by default, that role does not have the permissions required to perform ELB (de)registration. A minimal policy that would allow the required operations is as follows:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": ...,
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
