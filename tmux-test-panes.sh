#!/bin/bash

# open 4 GCP client VMs and 1 AWS client VM in brazil
xpanes -x -e -R 5 \
"gcloud compute ssh us-client --ssh-key-file=$HOME/.ssh/gino4096.openssh.key" \
"gcloud compute ssh eu-client --ssh-key-file=$HOME/.ssh/gino4096.openssh.key" \
"gcloud compute ssh apac-client --ssh-key-file=$HOME/.ssh/gino4096.openssh.key" \
"gcloud compute ssh brazil-client --ssh-key-file=$HOME/.ssh/gino4096.openssh.key" \
"ssh -i key-brazil.pem admin@ec2-18-230-152-3.sa-east-1.compute.amazonaws.com"

# URLs to clusters
#export URL_EKS_VA=http://a7e305a9f4ff1403988e7c2a2f347d7b-2081672395.us-east-1.elb.amazonaws.com
#export URL_GKE_VA=http://35.199.4.90

tmux set-window-option synchronize-panes on
tmux kill-pane