#!/bin/bash
#Create VPC Private_Subnet
aws ec2 create-vpc --cidr-block 10.10.0.0/22 --tag-specifications ResourceType=vpc,Tags='[{Key=Name,Value="Private_Subnet_AZ"}]'
VpcId1=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=Private_Subnet_AZ" --query 'Vpcs[*].{VpcId:VpcId}')
substring=${VpcId1%*}
Pris=$(echo $substring | cut -c15-35)
aws ec2 create-subnet --vpc-id $Pris --cidr-block 10.10.0.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Private_Subnet_1"}]'
aws ec2 create-subnet --vpc-id $Pris --cidr-block 10.10.1.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Private_Subnet_2"}]'
aws ec2 create-subnet --vpc-id $Pris --cidr-block 10.10.2.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Private_Subnet_3"}]'
aws ec2 create-vpc --cidr-block 10.10.4.0/22 --tag-specifications ResourceType=vpc,Tags='[{Key=Name,Value="Public_Subnet_AZ"}]'
#Create VPC Public_Subnet
VpcId2=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=Private_Subnet_AZ" --query 'Vpcs[*].{VpcId:VpcId}')
substring2=${VpcId2%*}
Pubs=$(echo $substring2 | cut -c15-35)
aws ec2 create-subnet --vpc-id $Pubs --cidr-block 10.10.4.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Public_Subnet_1"}]'
aws ec2 create-subnet --vpc-id $Pubs --cidr-block 10.10.5.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Public_Subnet_2"}]'
aws ec2 create-subnet --vpc-id $Pubs --cidr-block 10.10.6.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Public_Subnet_3"}]'
aws ec2 create-vpc --cidr-block 10.10.8.0/22 --tag-specifications ResourceType=vpc,Tags='[{Key=Name,Value="Database_Subnet_AZ"}]'
#Create VPC DB_Subnet
VpcId3=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=Private_Subnet_AZ" --query 'Vpcs[*].{VpcId:VpcId}')
substring3=${VpcId3%*}
DBs=$(echo $substring3 | cut -c15-35)
aws ec2 create-subnet --vpc-id $DBs --cidr-block 10.10.8.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Database_Subnet_1"}]'
aws ec2 create-subnet --vpc-id $DBs --cidr-block 10.10.9.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Database_Subnet_2"}]'
aws ec2 create-subnet --vpc-id $DBs --cidr-block 10.10.10.0/24 --tag-specifications ResourceType=subnet,Tags='[{Key=Name,Value="Database_Subnet_3"}]'
aws ec2 create-internet-gateway --tag-specifications ResourceType=internet-gateway,Tags='[{Key=Name,Value="Int-g"}]'
#Create InternetGateway
IntG=$(aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values= Int-g" --query 'InternetGateways[*].InternetGatewayId')
igw=$(echo $IntG | cut -c6-26)
#Attach igw to Public Subnet
aws ec2 attach-internet-gateway --vpc-id $Pubs --internet-gateway-id $igw
#GetID route table Public-Subnet
rtbp=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$Pubs" --query 'RouteTables[*].RouteTableId')
routeid=$(echo $rtbp| cut -c6-26)
#Add Default Route for Public 
aws ec2 create-route --route-table-id $routeid --destination-cidr 0.0.0.0/0 --gateway-id $igw
#Get ID Subnet 4
sub4=$( aws ec2 describe-subnets --filters "Name=cidr-block,Values=10.10.4.0/24" --query 'Subnets[*].SubnetId')
sub4id=$(echo $sub4| cut -c6-29)
aws ec2 associate-route-table --subnet-id $sub4id --route-table-id $routeid
#Lauch_Instance
aws ec2 run-instances --image-id ami-0c293f3f676ec4f90 --count 1 --instance-type t2.micro --key-name Test_EC2_Instan --security-group-ids sg-02083a3560b96169e --subnet-id $sub4id --associate-public-ip-address --tag-specifications ResourceType=instance,Tags='[{Key=Name,Value="Instance"}]
