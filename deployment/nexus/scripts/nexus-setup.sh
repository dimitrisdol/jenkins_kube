#!/bin/bash

ENV_PATH=~/Desktop/jenkins_kube/deployment/nexus/

#Check the perisstent volume you use for the Nexus deployment!!
NEXUS_DATA=/nexus-data

#Allow Nexus to use its data
sudo chown -R 200:200 ${NEXUS_DATA}

#Deploy the Nexus deployment
kubectl apply -f ${ENV_PATH}deployment.yaml

#Wait for the pod to come up
sleep 40

#Apply the service to expose the deployment
kubectl apply -f ${ENV_PATH}service.yaml

NODE_IP=$(minikube ip)
eval echo Here is the Nexus URL: ${NODE_IP}:32001
