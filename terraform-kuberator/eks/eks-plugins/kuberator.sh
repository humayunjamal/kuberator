#!/usr/bin/env bash

CLUSTER_NAME=$1
aws eks update-kubeconfig --name $CLUSTER_NAME

PLUGIN_DIR="."

# EKS CONFIG MAP TO ALLOW WOKER NODES TO JOIN THE CLUSTER and EXTRA USER AUTHENTICATION #####
kubectl apply -f $PLUGIN_DIR/config_map_aws_auth.yaml

kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/v1.5/aws-k8s-cni.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.5/config/v1.5/cni-metrics-helper.yaml

kubectl edit daemonset -n kube-system aws-node # Add/Update the env variable AWS_VPC_K8S_CNI_EXTERNALSNAT=true



# HELM BASE INSTALLATION
helm init
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
kubectl -n kube-system edit deploy tiller-deploy #(Update TILLER_HISTORY_MAX to 5)



# GRAFANA
helm install -f $PLUGIN_DIR/grafana-values.yaml stable/grafana --name grafana --namespace grafana

# KUBERNETES CLUSTER AUTO SCALER
kubectl apply -f $PLUGIN_DIR/k8_autoscaler_one_asg.yaml

# EKS DASHBOARD HELM chart
helm install -f $PLUGIN_DIR/k8-dashboard-values.yaml --name kubernetes-dashboard stable/kubernetes-dashboard --namespace kube-system

curl -o kube-state-metrics-1.5.zip https://codeload.github.com/kubernetes/kube-state-metrics/zip/release-1.5 && unzip kube-state-metrics-1.5.zip && kubectl apply -f kube-state-metrics-release-1.5/kubernetes

# NEW RELIC INFRSTRUCTUE AGENT FOR k8 ###
kubectl apply -f $PLUGIN_DIR/newrelic-infrastructure-k8s-latest.yaml

# Installing curator for elasticsearch and fluentd
#helm install --namespace kube-system --name curator --values curator-values.yaml stable/elasticsearch-curator
kubectl apply -f $PLUGIN_DIR/fluentd-with-configs.yaml

sleep 30

# METRICS SERVER
kubectl apply -f metrics-server/

# KUBERNETES ALB INGRESS CONTROLLER
kubectl apply -f $PLUGIN_DIR/alb-ingress-controller.yaml

# Install nginx controller to disable default ELB entry point and serve from NodePort
helm install -f $PLUGIN_DIR/nginx-ingress-values.yaml stable/nginx-ingress --name nginx-ingress --namespace kube-system
kubectl apply -f $PLUGIN_DIR/nginx-ingress+alb-controller-external.yaml
kubectl apply -f $PLUGIN_DIR/nginx-ingress+alb-controller-internal.yaml

# EXTERNAL DNS TO MANAGE ROUTE53 records
kubectl apply -f $PLUGIN_DIR/external-dns.yaml

# Apply dns-autoscaler
kubectl apply -f $PLUGIN_DIR/dns-autoscaler.yaml


# CONFIGURE DESCHEDULER 

kubectl apply -f $PLUGIN_DIR/k8-descheduler.yaml