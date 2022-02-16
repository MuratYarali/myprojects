#!/bin/bash

sed -i "s/ec2-private_ip/$(cat info.json | grep -i PrivateIpAddress | head -1 | cut -d'"' -f 4)/" terraform.tf