# kuberator
A recipe for Prod Grade EKS with perfect ADD ons 


Please read the blog :

https://medium.com/alef-education/kubernetes-recipe-aka-kuberator-108ca397126d

to get the full idea of what is being created otherwise the code itself is documentation 

```
cd eks 

terraform init
terraform plan
terraform apply
```

According to the module configurations you can create SPOT ASG per AZ or ON DEMAND ASG per AZ or a combination of both with SYSTEM WORKER NODES ASG 

Please review all the files to provide appropriate values for eg VPC ID , Subnet IDS , ASG names in terraform codebase and plugin configurations in eks-plugins directory. 

kuberator.sh file is the actual recipe of the k8 add ons 