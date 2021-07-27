# These scripts are used for creating the docker image for cluster manager.

Once you have deploy a kubernetes cluster on AWS using kops, 
these scrips can help you buid a cluster image using docker for backup, 
which can be used to deploy a new manager for the cluster deploy new product.

The crutial part of these scrips is the config.yaml file. This file is a copy of "~/.kube/config" from the original machine where you deploy the k8s cluster on AWS.
This config file recoreds the cluster configuration infomation and can be used in the new instance.

## Docker image building steps are as follows.
```
docker build -t <image tag> .
docker tag <image tag> <docker registroy and image path>
docker login in <docker registory server>
docker push <docker registroy and image path>
```
## Run the manager container
```
docker run -it <image tag> sh
```
