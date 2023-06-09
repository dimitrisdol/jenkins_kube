#!/bin/bash

#Path of project locally to execute the script.
ENV_PATH=~/Desktop/jenkins_kube/deployment/jenkins-setup/

# Create the minikube cluster that will handle the etnire infrastructure.
minikube start --driver docker --delete-on-failure --nodes 3 --subnet "192.168.49.0/24" --memory 16384 --cpus 3 --insecure-registry 192.168.49.2:32002

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

#Apply the serviceaccount that allows the default service to deploy via the pipeline (AVOID IN PRODUCTION)
kubectl apply -f ${ENV_PATH}deployment_serviceAccount.yaml

#Create necessary secrets if needed!
kubectl create secret generic gitlab-certificate --from-file=cert=home/jim/git-certs/cert.crt

#keytool -import -alias gitlab -keystore /opt/java/openjdk/lib/security/cacerts -file /etc/gitlab-certs/cert -storepass changeit -noprompt
#cp /etc/gitlab-certs/cert /usr/local/share/ca-certificates/gitlab-dg11.crt
#update-ca-certificates

NODE_IP=$(minikube ip)
eval echo Here is the Jenkins URL: ${NODE_IP}:32000

echo "Here is the initialAdmin password"

export POD=$(kubectl get pods -n devops-tools --no-headers -o custom-columns=":metadata.name" | grep -i jenkins)

kubectl exec pods/$POD -n devops-tools -it cat /var/jenkins_home/secrets/initialAdminPassword
