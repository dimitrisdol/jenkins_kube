#!/bin/bash

#Path of project locally to execute the script.
ENV_PATH=~/Desktop/jenkins_kube/jenkins/kube-deployment/

# Create the minikube cluster that will handle the etnire infrastructure.
minikube start --driver docker --delete-on-failure --nodes 3 --subnet "192.168.49.0/24" 

# Wait for the cluster setup to finish.
sleep 60 

# Create a separate namespace for our tools.
kubectl create namespace devops-tools

# Apply the serviceAccount yaml to create the clusterRole and to bind it to the Service Account. This allows us to manage all cluster components.
kubectl apply -f ${ENV_PATH}serviceAccount.yaml

# Create the persistent volume used by the Jenkins pod.
kubectl apply -f ${ENV_PATH}volume.yaml

# Now apply the deployment yaml that created the Jenkins pod.
kubectl apply -f ${ENV_PATH}deployment.yaml

# Wait for the Pod to start.
sleep 40

# Then we apply the service to expose the Jenkins service to our localhost.
kubectl apply -f ${ENV_PATH}service.yaml

NODE_IP=$(minikube ip)
eval echo Here is the Jenkins URL: ${NODE_IP}:32000
