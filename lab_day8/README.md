
_________________________Use SSM Endpoint Connect Private Network
Document Referent:https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/
#aws ec2 create-vpc --cidr-block 172.16.0.0/22 --tag-specifications ResourceType=vpc,Tags='[{Key=Name,Value="Private_Subnet_AZ"}]'
#VpcId1=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=Private_Subnet_AZ" --query 'Vpcs[*].{VpcId:VpcId}')
substring=${VpcId1%*}
#Pris=$(echo $substring | cut -c15-35)
#aws ec2 create-subnet --vpc-id $Pris --cidr-block 172.16.0.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Private_Subnet_1"}]'
#aws ec2 create-security-group --group-name SG2 --description "SG2-Private" --vpc-id $Pris 
#secgid=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$Pris" --query 'SecurityGroups[*].GroupId')
#SecId=$(echo $secgid| cut -c4-23)
#SecRule=$(aws ec2 describe-security-group-rules --filters "Name=group-id,Values=$SecId" --query 'SecurityGroupRules[0].SecurityGroupRuleId')
#SecruleId=$(echo $SecRule| cut -c2-22)
#aws ec2 revoke-security-group-ingress --group-id $SecId --security-group-rule-ids $SecruleId

#aws ec2 authorize-security-group-ingress --group-id $SecId --protocol tcp --port 22 --cidr 0.0.0.0/0
#aws ec2 authorize-security-group-ingress --group-id $SecId --protocol tcp --port 443 --cidr 0.0.0.0/0
Create Instances with Private Subnet
#aws ec2 run-instances --image-id ami-0c293f3f676ec4f90 --count 1 --instance-type t2.micro --key-name Test_EC2_Instan --security-group-ids sg-01318227e60ebc474 --subnet-id subnet-07688e6c5187c8acc --tag-specifications ResourceType=instance,Tags='[{Key=Name,Value="Instance"}]'
Attach EC2-Role 
#aws ec2 associate-iam-instance-profile --instance-id i-0a2e1409bad75c247 --iam-instance-profile Name=Role_EC2_Backup
Create VPC-Endpoint
![Screenshot_14](https://user-images.githubusercontent.com/85090024/162113689-59b2df39-d814-430b-b254-06f78cbc0f1e.png)
Note: Enable DNS in VPC and Endpoint
![Screenshot_13](https://user-images.githubusercontent.com/85090024/162141491-c9917765-0c2a-41a0-91e2-90098c8daf84.png)
![Screenshot_11](https://user-images.githubusercontent.com/85090024/162141521-554edca4-0e77-41b9-add5-8e2ff00cde94.png)
_____________Peering
Create Peering
![Screenshot_5](https://user-images.githubusercontent.com/85090024/162142076-7a0f43d7-f9ca-4dad-ab69-9ad544743dee.png)
Note: Wait For Accept Request
Add Route
![Screenshot_7](https://user-images.githubusercontent.com/85090024/162142206-8da272f3-c5ce-41aa-9fc4-bde6fc9f2047.png)
![Screenshot_8](https://user-images.githubusercontent.com/85090024/162142222-a345b124-71bc-47f9-a4dc-42c502ba8725.png)
![Screenshot_9](https://user-images.githubusercontent.com/85090024/162142264-fd2d1043-ae61-4c97-9f95-b06e054d1892.png)
Allow Ping and SSH
![Screenshot_13](https://user-images.githubusercontent.com/85090024/162142331-0ddc4de3-8f79-485d-897c-fd1f0a2cd726.png)
Connect From EC2 to EC2 Peering 
![Screenshot_12](https://user-images.githubusercontent.com/85090024/162142439-d16a5707-cd36-4422-880b-dc79100cdb87.png)
