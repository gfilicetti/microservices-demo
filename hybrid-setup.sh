#!/bin/sh

# Overview on Multi cluster networking
# https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-ingress#multi-cluster_networking

# setting up a multi cluster ingress fleet
# https://cloud.google.com/kubernetes-engine/docs/how-to/multi-cluster-ingress-setup#workload-identity_1

# us-central1 = onlineboutique
# southamerica-east1 = onlineb-auto
# Both need to have workload identity enabled (this is not the default)

# rename the kube context for my clusters
kubectl config rename-context gke_discoveryhybridingress_us-central1-b_onlineboutique ob-gke-us
kubectl config rename-context gke_discoveryhybridingress_southamerica-east1_onlineb-auto ob-gke-brazil
kubectl config rename-context arn:aws:eks:us-east-1:418892013406:cluster/onlineb-eks ob-eks-us
kubectl config rename-context arn:aws:eks:eu-west-1:418892013406:cluster/onlineb-eks-eu ob-eks-eu

# Register two GKE clusters with a fleet
gcloud container hub memberships register onlineboutique  \
    --gke-cluster us-central1/onlineboutique \
    --enable-workload-identity \
    --project=discoveryhybridingress

gcloud container hub memberships register onlineb-auto \
    --gke-cluster southamerica-east1/onlineb-auto \
    --enable-workload-identity \
    --project=discoveryhybridingress

# Confirm they are registered
gcloud container hub memberships list --project=discoveryhybridingress

# Set the onlineboutique cluster in us-central as our "Multi Cluster Ingress" controller
gcloud container hub ingress enable --config-membership=onlineboutique

# check that all is good
gcloud container hub ingress describe


# Installing an ingress for an app installed across all clusters
# https://cloud.google.com/kubernetes-engine/docs/how-to/multi-cluster-ingress
# Concept of Multi Cluster Ingress: https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-ingress

# confirm that we've got two clusters
gcloud container clusters list

# add the 'whereami' and 'onlineboutique' namespace to all clusters
# see file: namespace.yaml 
kubectl config use-context ob-eks-us
kubectl apply -f ns-onlineboutique.yaml
kubectl apply -f ns-whereami.yaml

kubectl config use-context ob-eks-eu
kubectl apply -f ns-onlineboutique.yaml
kubectl apply -f ns-whereami.yaml

kubectl config use-context ob-gke-us
kubectl apply -f ns-onlineboutique.yaml
kubectl apply -f ns-whereami.yaml

kubectl config use-context ob-gke-brazil
kubectl apply -f ns-onlineboutique.yaml
kubectl apply -f ns-whereami.yaml

# use the onlineboutique NS as default because it is not specified in the microservices-demo code
kubectl config set-context ob-eks-us --namespace=onlineboutique
kubectl config set-context ob-eu-us --namespace=onlineboutique
kubectl config set-context ob-gke-us --namespace=onlineboutique
kubectl config set-context ob-gke-brazil --namespace=onlineboutique

# deploy the 'whereami' app to all clusters
# see file: deploy-whereami.yaml 
kubectl config use-context ob-eks-us
kubectl apply -f deploy-whereami.yaml

kubectl config use-context ob-eks-eu
kubectl apply -f deploy-whereami.yaml

kubectl config use-context ob-gke-us
kubectl apply -f deploy-whereami.yaml

kubectl config use-context ob-gke-brazil
kubectl apply -f deploy-whereami.yaml

# deploy the 'onlineboutique' app to all clusters
# see the microservices-demo repo
kubectl config use-context ob-eks-us
kubectl apply -f ./release/kubernetes-manifests.yaml

kubectl config use-context ob-eks-eu
kubectl apply -f ./release/kubernetes-manifests.yaml

kubectl config use-context ob-gke-us
kubectl apply -f ./release/kubernetes-manifests.yaml

kubectl config use-context ob-gke-brazil
kubectl apply -f ./release/kubernetes-manifests.yaml

# deploy the 'whereami' and 'onlineboutique' MultiClusterService to the config cluster only
# see file: mcs-whereami.yaml
kubectl config use-context ob-gke-us
kubectl apply -f mcs-whereami.yaml
kubectl apply -f mcs-onlineboutique.yaml

# deploy the 'whereami' and 'onlineboutique' MultiClusterIngress to the config cluster only
# see file: mci-whereami.yaml
kubectl config use-context ob-gke-us
kubectl apply -f mci-whereami.yaml
kubectl apply -f mci-onlineboutique.yaml

# Deploying the MCI needs time, use this command to check on the status
kubectl describe mci whereami-ingress -n whereami
kubectl describe mci onlineboutique-ingress
# when it is ready, look for a VIP line in the status with an IP address like this:
#   VIP:        34.111.27.189
