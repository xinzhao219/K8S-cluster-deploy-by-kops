# These scripts are used for creating the docker image for cluster manager.

Once you have deploy a kubernetes cluster on AWS using kops, 
these scrips can help you buid a cluster image using docker for backup, 
which can be used to deploy a new manager for the cluster deploy new product.

The crutial part of these scrips is the config.yaml file. This file is a copy of "~/.kube/config" from the original machine (e.g. your laptop) where you deploy the k8s cluster on AWS.
This config file recoreds the cluster configuration infomation and can be used in the new instance.

## Docker image building steps are as follows.
```
docker build -t kopscluster .
docker tag kopscluster xinzhao.jfrog.io/product-docker/kopscluster:1.0.2
docker login xinzhao.jfrog.io
docker push xinzhao.jfrog.io/product-docker/kopscluster:1.0.2
```
## Run the manager container
```
docker run -it kopscluster sh
```
