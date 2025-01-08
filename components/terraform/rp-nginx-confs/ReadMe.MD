### Create cloudfront_ips.conf
Run following commands in bash to create cloudfront_ips.conf containing all global
IP addresses of CloudFront locations.
```
curl https://ip-ranges.amazonaws.com/ip-ranges.json > amazon-ips.json
jq -r '.prefixes[] | select(.service=="CLOUDFRONT") | .ip_prefix' < amazon-ips.json > list.txt
rm -f amazon-ips.json
sort -g list.txt > cloudfront_ips.conf
rm -f list.txt
ex +'%s/^/set_real_ip_from /g' -cwq cloudfront_ips.conf
ex +'%s/$/;/g' -cwq cloudfront_ips.conf
```

If locations should be limited by specific regions of the CloudFront distribution:
```
jq -r '.prefixes[] | select(.region=="[region]") | select(.service=="CLOUDFRONT") | .ip_prefix' < amazon-ips.json >> list.txt
```
replace [region] with the appropriate value(s);     
this command appends the results;   
for more information about filtering the IP json file use https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html;

Currently European regions are:

Franfurt:eu-central-1 	
Ireland: eu-west-1 	
London: eu-west-2 	
Milan: eu-south-1 	
Paris: eu-west-3 	
Stockholm: eu-north-1

US regions:
N. Virginia: us-east-1 	
Ohio: us-east-2 	
N. California: us-west-1 	
Oregon: us-west-2
