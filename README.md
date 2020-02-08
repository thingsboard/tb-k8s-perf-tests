# Kubernetes resources configuration for ThingsBoard Microservices

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Microservices mode.

## Prerequisites

ThingsBoard Microservices are running on Kubernetes cluster.
You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster.

Current supported versions: 

- kubectl **1.17.0**
- kops **1.15.0 (git-9992b4055)**

Follow [Getting Started with kops on AWS](https://github.com/kubernetes/kops/blob/master/docs/getting_started/aws.md)
to prepare necessary tools for deploying cluster on AWS using kops.


Install [Docker CE](https://docs.docker.com/install/) and do the login to the Docker Cloud.

Please make sure that you are able to run:

`
docker run hello-world
`

## Generate ssh key for kops resources

By default ssh key that is located in the *~/.ssh/kops.pub* is going to be used to access kops resources.
Pleaes execute the following command to create this ssh key (please enter **/home/[YOUR_USER_NAME]/.ssh/kops** file name during key generation procedure):

`
$ ssh-keygen
`

Sample:
```
$ voba@voba-desktop:~/projects/tb-pe-k8s-perf-tests$ ssh-keygen 
$ Generating public/private rsa key pair.
$ Enter file in which to save the key (/home/voba/.ssh/id_rsa): /home/voba/.ssh/kops
$ ...
```

You can use your custom ssh key, but in that case please update **SSH_PUBLIC_KEY** property in the *.env* file and set it to your custom ssh key.


## Deploy Cluster

Execute the following command to deploy cluster:

`
$ ./cluster-deploy.sh
`

Wait until cluster is ready. Execute the following command to check cluster status:

`
$ ./cluster-validate.sh
`

## Deploy Dashboard

`
$ ./k8s-deploy-metrics.sh
`

**NOTE** Kubernetes Dashboard will ask twice for the same admin credentials during initial login.


## ThingsBoard Microservices Installation

Execute the following command to run installation:

`
$ ./k8s-install-tb.sh --loadDemo
`

Where:

- `--loadDemo` - optional argument. Whether to load additional demo data.

## Running

Execute the following command to deploy resources:

`
$ ./k8s-deploy-resources.sh
`

Before running install script, please make sure that cluster is running fine.

You can execute following command to download tb-node logs:

`
$ ./k8s-tb-node-logs.sh
`

This script will create **tb-node-logs** folder, which will contain latest tb-node logs. Please search for any **ERROR** inside log files. If no errors, you can go to next steps.

Next step we are going create devices:

`
$ ./k8s-install-performance.sh
`

### API test

Execute the following command to start pefrormance test for 1000000 Devices:

`
$ ./k8s-run-performance.sh
`

### Test results

After a while when all resources will be successfully started you can open `http://{your-cluster-ip}` in you browser (for ex. `http://192.168.99.101`).
You should see ThingsBoard login page.

Execute the following command to get your cluster web ui host information:

`
$ kubectl get services ingress-nginx -owide --namespace kube-ingress
`

OR:

`
$ kubectl get ingress.extensions
`

Use the following default credentials:

- **System Administrator**: sysadmin@thingsboard.org / sysadmin

If you installed DataBase with demo data (using `--loadDemo` flag) you can also use the following credentials:

- **Tenant Administrator**: tenant@thingsboard.org / tenant
- **Customer User**: customer@thingsboard.org / customer

In case of any issues you can examine service logs for errors.
For example to see ThingsBoard node logs execute the following commands:

1) Get list of the running tb-node pods:

`
$ kubectl get pods -l app=tb-node
`

2) Fetch logs of tb-node pod:

`
$ kubectl logs -f [tb-node-pod-name]
`

Where:

- `tb-node-pod-name` - tb-node pod name obtained from the list of the running tb-node pods.

Or use `kubectl get pods` to see the state of all the pods.
Or use `kubectl get services` to see the state of all the services.
Or use `kubectl get deployments` to see the state of all the deployments.
See [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) command reference for details.

Use the following command to get pods and associated nodes:

`
$ kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces
`

## Upgrading

In case when database upgrade is needed, execute the following commands:

```
$ ./k8s-delete-resources.sh
$ ./k8s-upgrade-tb.sh --fromVersion=[FROM_VERSION]
$ ./k8s-deploy-resources.sh
```

Where:

- `FROM_VERSION` - from which version upgrade should be started. See [Upgrade Instructions](https://thingsboard.io/docs/user-guide/install/upgrade-instructions) for valid `fromVersion` values.

## Uninstallation

Execute the following command to delete all deployed microservices:

`
$ ./k8s-delete-resources.sh
`

Execute the following command to delete all resources (including database):

`
$ ./k8s-delete-all.sh
`

## Delete cluster

Execute the following command to completely delete cluster:

`
$ ./cluster-delete.sh
`
