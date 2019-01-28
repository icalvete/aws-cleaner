## AWS Cleaner

[![Build Status](https://travis-ci.org/icalvete/aws-cleaner.svg?branch=master)](https://travis-ci.org/eheydrick/aws-cleaner)

AWS Cleaner listens for EC2 termination events produced by AWS [CloudWatch Events](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/WhatIsCloudWatchEvents.html)
and removes the instances from Sensu Monitoring.

![aws-cleaner](https://raw.github.com/icalvete/aws-cleaner/master/aws-cleaner.png)

### Prerequisites

You will need to create a CloudWatch Events rule that's configured to send termination event messages to SQS.

1. Create an SQS Queue for cloudwatch-events
1. Goto CloudWatch Events in the AWS Console
1. Click *Create rule*
1. Select event source of *EC2 instance state change notification*
1. Select specific state of *Terminated*
1. Add a target of *SQS Queue* and set queue to the cloudwatch-events queue created in step one
1. Give the rule a name/description and click *Create rule*

An astute reader might notice that this wont work for new nodes that come up as they have not had their ACL updated. I recommend that you add the who bulk acl knife commands (modified for just self as opposed to bulk) as part of your normal bootstrap process before deleting your validation key.

### Installation

1. `gem install aws-cleaner`

### Usage

```
Options:
  -c, --config=<s>    Path to config file (default: config.yml)
  -h, --help          Show this message
```

Copy the example config file ``config.yml.sample`` to ``config.yml``
and fill in the configuration details. You will need AWS Credentials
and are strongly encouraged to use an IAM user with access limited to
the AWS CloudWatch Events SQS queue.You will need to specify the region
in the config even if you are using IAM Credentials.

The app takes one arg '-c' that points at the config file. If -c is
omitted it will look for the config file in the current directory.

The app is started by running aws_config.rb and it will run until
terminated. A production install would start it with upstart or
similar.

### Logging

By default aws-cleaner will log to STDOUT. If you wish to log to a specific file
add a `log` section to the config. See [`config.yml.sample`](config.yml.sample) for an example.

### Sensu

You will want the following config:
```
:sensu:
  :url: 'http://sensu.example.com:4567'
  :enable: true
```

### Limitations

- Currently only supports a single AWS region.
- Only support sensu with non self signed certificates. Look at Aws Certificate Manager or Let's Encrypt for free SSL certificates.
