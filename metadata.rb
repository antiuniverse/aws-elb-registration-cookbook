name             'aws-elb-registration'
maintainer       'Zach Brockway'
maintainer_email 'neverender@gmail.com'
license          'Apache 2.0'
description      'Provides recipes to trigger AWS instance registration with (or deregistration from) one or more Elastic Load Balancers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'awscli'