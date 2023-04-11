#!/bin/bash

ENV_PATH=~/Desktop/jenkins_kube/deployment/nexus/

#Check the persistent volume you use for the Nexus deployment!!
kubectl create -f ${ENV_PATH}volume.yaml

#Deploy the Nexus deployment
kubectl apply -f ${ENV_PATH}deployment.yaml

#Wait for the pod to come up
sleep 40

#Apply the service to expose the deployment
kubectl apply -f ${ENV_PATH}service.yaml

NODE_IP=$(minikube ip)
eval echo Here is the Nexus URL: ${NODE_IP}:32001
