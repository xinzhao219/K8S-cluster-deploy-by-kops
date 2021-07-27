# K8S-cluster-deploy-by-kops

Install kops on your laptop
curl -Lo kops https://github.com/kubernetes/kops/releases/download/v1.18.0/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

Set Environment variables
export KOPS_CLUSTER_NAME=devops.k8s.local
export KOPS_STATE_STORE=s3://xin-terraform-state-dev
export AWS_PROFILE="devops"
export AWS_ACCESS_KEY_ID=$(aws configure get devops.aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get devops.aws_secret_access_key)

Create token for cluster using ssh-keygen
mkdir .ssh
ssh-keygen 

Create cluster configuration
kops create cluster \
--cloud aws \
--master-size t2.micro \
--master-count 1 \
--master-zones ap-southeast-2a \
--node-count=1 \
--node-size=t2.micro \
--zones=ap-southeast-2a \
--name=${KOPS_CLUSTER_NAME} \
--vpc=vpc-00ab4fd9c9497fec3 \
--subnets=subnet-0e58b9aadfa246469,subnet-0189e27b9abab09fa \
--ssh-public-key="/root/.ssh/kops.pub"

Edit cluster configuration
•	change root volume size for nodes
  kops edit ig --name=devops.k8s.local nodes
  
apiVersion: kops.k8s.io/v1alpha2
kind: InstanceGroup
metadata:
  creationTimestamp: "2021-07-26T02:41:38Z"
  generation: 1
  labels:
    kops.k8s.io/cluster: devops.k8s.local
  name: nodes
spec:
  image: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210503
  machineType: t2.micro
  maxSize: 1
  minSize: 1
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  role: Node
  rootVolumeSize: 10
  rootVolumeType: gp2
  subnets:
  - ap-southeast-2a
  
•	change root volume size for master
kops edit ig --name=devops.k8s.local master-ap-southeast-2a

apiVersion: kops.k8s.io/v1alpha2
kind: InstanceGroup
metadata:
  creationTimestamp: "2021-07-26T02:41:38Z"
  labels:
    kops.k8s.io/cluster: devops.k8s.local
  name: master-ap-southeast-2a
spec:
  image: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210503
  machineType: t2.micro
  maxSize: 1
  minSize: 1
  nodeLabels:
    kops.k8s.io/instancegroup: master-ap-southeast-2a
  role: Master
  rootVolumeSize: 10
  rootVolumeType: gp2
  subnets:
  - ap-southeast-2a
  
•	change volume size for etcd
kops edit cluster --name=devops.k8s.local --state=s3://xin-terraform-state-dev

etcdClusters:
  - cpuRequest: 200m
    etcdMembers:
    - instanceGroup: master-ap-southeast-2a
      name: a
      volumeSize: 5 
    memoryRequest: 100Mi
    name: main
  - cpuRequest: 100m
    etcdMembers:
    - instanceGroup: master-ap-southeast-2a
      name: a
      volumeSize: 5
    memoryRequest: 100Mi
    name: events

Create cluster on aws
kops update cluster --name devops.k8s.local --yes

Testing the cluster
deploy nginx.yaml and svc.yaml, you can use the link like below to view nginx server welcome page.
a8eaa64bd68b44c37b03601e6b1e16d7-08d39e07e1b52711.elb.ap-southeast-2.amazonaws.com

Delete the cluster after the experiment.
kops delete cluster --name ${KOPS_CLUSTER_NAME} --yes
