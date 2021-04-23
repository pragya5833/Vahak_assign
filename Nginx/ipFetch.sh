publicIPS=$(aws ec2 describe-instances --region ap-south-1 --instance-ids $(aws autoscaling describe-auto-scaling-instances --region us-east-1 --output text \
--query "AutoScalingInstances[?AutoScalingGroupName=='nginxBehindASG'].InstanceId") --query "Reservations[].Instances[].PublicIpAddress" --output text)
echo "$publicIPS"
healthCheck='max_fails=4 fail_timeout=30s'
serverConfig=$(echo "{"
for i in $publicIPS
do
  echo "       server  $i $healthCheck;"
done
echo "}")
echo "$serverConfig"
nginxConf=$(awk -v srch="serverIPS" -v repl="$serverConfig" '{gsub(srch,repl)} 1' ./Nginx/nginx.conf)
echo "$nginxConf" > /etc/nginx/nginx.conf
sudo service nginx reload

