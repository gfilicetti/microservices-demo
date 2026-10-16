#!/bin/sh

# Commands from this tutorial: 
#   https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html

# Regions to use:
# us-east-1: Virginia
# eu-west-1: Ireland
# sa-east-1: Sao Paolo
REGION="sa-east-1"

# GF: Create the necessary vpc for our region
aws cloudformation create-stack \
  --region $REGION \
  --stack-name $REGION-eks-vpc-stack \
  --template-url https://amazon-eks.s3.us-west-2.amazonaws.com/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml

# GF: Create cluster IAM role (using json file)
aws iam create-role \
  --role-name myAmazonEKSClusterRole \
  --assume-role-policy-document file://"aws-cluster-role-trust-policy.json"

# GF: Attach policy to role
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy \
  --role-name myAmazonEKSClusterRole

# GF: Create a nodegroup IAM role
# NOTE: it is recommended to create new roles for different node groups
aws iam create-role \
  --role-name myAmazonEKSNodeRole \
  --assume-role-policy-document file://"aws-node-role-trust-policy.json"

# GF: Attach IAM policies to the role
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy \
  --role-name myAmazonEKSNodeRole
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
  --role-name myAmazonEKSNodeRole
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy \
  --role-name myAmazonEKSNodeRole






