# Kubernetes resources configuration for ThingsBoard Microservices

This folder containing scripts and Kubernetes resources configurations to run ThingsBoard in Microservices mode.

## Prerequisites

ThingsBoard Microservices are running on Kubernetes cluster.
You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster.
Follow [Getting Started with kops on AWS](https://github.com/kubernetes/kops/blob/master/docs/getting_started/aws.md)
to prepare necessary tools for deploying cluster on AWS using kops.

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

## ThingsBoard Microservices Installation

Execute the following command to upload docker credentials for pulling private images:

`
$ ./k8s-upload-docker-credentials.sh
`

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

Execute the following command to install performance data:

`
$ ./k8s-install-performance.sh
`


Execute the following command to start performance test:

`
$ ./k8s-run-performance.sh
`

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

Execute the following command to get your cluster mqtt host information:

`
$ kubectl get service tb-mqtt-transport
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
