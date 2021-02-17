# udacity-cloud-devops-capstone

1. create cluster
````
eksctl create cluster --name udacity --region eu-west-1 --fargate
eksctl create nodegroup --cluster udacity --node-type t3.medium --nodes 1 --ssh-access --ssh-public-key udacity
aws eks --region eu-west-1 update-kubeconfig --name udacity
````

2. prepare namespace
````
kubectl create ns petclinic
kubectl config set-context --current --namespace=petclinic
````

3. create deployment and service
````
kubectl create deployment petclinic --image fnan/udacity-cloud-devops-spring-petclinic:1.0.0-b30 --port 8080 --replicas 2
kubectl expose deployment petclinic --port=80 --target-port=8000 --type LoadBalancer
````


4. update deployment
````
kubectl set image deployment/petclinic petclinic=fnan/udacity-cloud-devops-spring-petclinic:2.4.2-b4
kubectl rollout status -w deployment/petclinic
````