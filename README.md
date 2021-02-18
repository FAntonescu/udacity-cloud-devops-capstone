# udacity-cloud-devops-capstone

This project is used as the Capstone project for the Udacity Cloud DevOps nanodegree programe. 

It contains the Java web application Spring Pet Clinic application https://github.com/spring-projects/spring-petclinic 
a Dockefile for building a Docker image with the web application
and the CircleCI CI/CD configuration for deploying the Docker image to AWS EKS.

## Prerequisites 

In order to prepare the AWS EKS cluster the CLI tools `aws` and `kubectl` have to be installed in the lolcal development environment.

## Prepare the Kubernetes cluster on AWS EKS

0. Initialize the AWS credentials
Set the AWS Access Key ID, AWS Secret Access Key and AWS default region
````
aws configure
````

1. Create a new EKS cluster using AWS Fargate
````
# create a new cluster named udacity in the AWS region eu-west-1
eksctl create cluster --name udacity --region eu-west-1 --fargate

# add a new worker node to the cluster
eksctl create nodegroup --cluster udacity --node-type t3.medium --nodes 1 --ssh-access --ssh-public-key udacity

# configure the kubectl to use the newly created Kubernetes cluster
aws eks --region eu-west-1 update-kubeconfig --name udacity
````

2. Create a new Kubernetes namespace
````
kubectl create ns petclinic
kubectl config set-context --current --namespace=petclinic
````

3. Create deployment and service for the PetClinic application
````
# create a Kubernetes deployment configured with the rolling upgrade strategy (default) 
# using the Docker image docker.io/fnan/udacity-cloud-devops-spring-petclinic:1.0.0-b30
# exposing the Spring Boot port 8080
# with two instances (replicas)
kubectl apply -f ./k8s/deployment.yml

# create a Kubernetes service of type Load Balancer
kubectl apply -f ./k8s/service.yml
````

4. update the Docker image of the Kubernetes deployment
````
kubectl set image deployment/petclinic petclinic=docker.io/fnan/udacity-cloud-devops-spring-petclinic:2.4.2-b4
kubectl rollout status -w deployment/petclinic
````

## Verify the application locally

In order to confirm that the application is working locally, build it with the Maven wrapper
````
./mwnw clean package
````

Start the application locally by running `./mwnw spring-boot:run`

Open the browser and navigate to http://localhost:8080/ to access the web application.

Close the application by pressing Ctrl + C in the terminal where the application is running.

## Build the Docker image locally

Verify that the Docker file is syntactically correct by executing `hadolint Dockerfile` in the same folder with the `Dockerfile`. 

Once the code has been packaged it can be built into a Docker image by running `docker build -t petclinic .`
Once the Docker image is built it can be run with the command `docker run --rm -it petclinic`

Open the browser and navigate to http://localhost:8080/ to access the web application.

Close the application by pressing Ctrl + C in the terminal where the application is running.
