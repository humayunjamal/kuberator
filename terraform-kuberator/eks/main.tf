module "eks" {
  source                        = "../terraform-modules/eks"
  create_spot_workers           = false
  instance_type                 = "m5.2xlarge"
  aws_private_subnet_ids        = "${data.aws_subnet_ids.net_private.ids}"
  aws_vpc_net_id                = "${data.aws_vpc.net.id}"
  cluster-name                  = "my-cluster"
  environment                   = "production"
  aws_image_id                  = "${data.aws_ami.k8-worker.id}"
  key_name                      = "my-keypair"
  eks-version                   = "1.13"
  team_name                     = "Kuberator"
  team_owner                    = "King"
  min_size_ondemand             = 1
  max_size_ondemand             = 10
  desired_capacity_ondemand     = 1
  min_size_ondemand-system-node = 1
  max_size_ondemand-system-node = 10
  desired_capacity_system-node  = 1
}

resource "null_resource" "kuberator" {
  provisioner "local-exec" {
    command = "cd ./eks-plugins;./kuberator.sh my-cluster"
  }
}
