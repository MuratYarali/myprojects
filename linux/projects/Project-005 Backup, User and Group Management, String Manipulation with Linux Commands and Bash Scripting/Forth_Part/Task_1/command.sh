1.Bolum : 
sed -i "s/ec2-private_ip/$(grep PrivateIpAddress info.json | head -n1 | cut -d'"' -f4)/g" terraform.tf

2.Bolum : 
