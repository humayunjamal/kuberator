locals {
  k8-worker-userdata-1a = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2OnDemand,az=1a' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
USERDATA

  k8-worker-userdata-1b = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2OnDemand,az=1b' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
USERDATA

  k8-worker-userdata-1c = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2OnDemand,az=1c' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
USERDATA
}

###### AVAILAIBILITY ZONE 1A  ASG ########

resource "aws_launch_configuration" "k8-worker-lc-1a" {
  count                       = "${var.create_az_based_workers}"
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.k8-worker.name}"
  image_id                    = "${var.aws_image_id}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.environment}-k8-worker-lc-1a-"
  security_groups             = ["${aws_security_group.k8-worker.id}"]
  user_data_base64            = "${base64encode(local.k8-worker-userdata-1a)}"
  key_name                    = "${var.key_name}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8-worker-asg-1a" {
  count                = "${var.create_az_based_workers}"
  desired_capacity     = "${var.desired_capacity_ondemand}"
  launch_configuration = "${aws_launch_configuration.k8-worker-lc-1a.id}"
  max_size             = "${var.max_size_ondemand}"
  min_size             = "${var.min_size_ondemand}"
  termination_policies = ["OldestInstance"]
  name                 = "${var.environment}-k8-worker-1a"
  vpc_zone_identifier  = ["${var.aws_private_subnet_id_1a}"]

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-1a"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Team"
    value               = "${var.team_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.team_owner}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["desired_capacity"]
  }
}

###### AVAILAIBILITY ZONE 1B  ASG ########

resource "aws_launch_configuration" "k8-worker-lc-1b" {
  count                       = "${var.create_az_based_workers}"
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.k8-worker.name}"
  image_id                    = "${var.aws_image_id}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.environment}-k8-worker-lc-1b-"
  security_groups             = ["${aws_security_group.k8-worker.id}"]
  user_data_base64            = "${base64encode(local.k8-worker-userdata-1b)}"
  key_name                    = "${var.key_name}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8-worker-asg-1b" {
  count                = "${var.create_az_based_workers}"
  desired_capacity     = "${var.desired_capacity_ondemand}"
  launch_configuration = "${aws_launch_configuration.k8-worker-lc-1b.id}"
  max_size             = "${var.max_size_ondemand}"
  min_size             = "${var.min_size_ondemand}"
  termination_policies = ["OldestInstance"]
  name                 = "${var.environment}-k8-worker-1b"
  vpc_zone_identifier  = ["${var.aws_private_subnet_id_1b}"]

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-1b"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Team"
    value               = "${var.team_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.team_owner}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["desired_capacity"]
  }
}

###### AVAILAIBILITY ZONE 1C  ASG ########

resource "aws_launch_configuration" "k8-worker-lc-1c" {
  count                       = "${var.create_az_based_workers}"
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.k8-worker.name}"
  image_id                    = "${var.aws_image_id}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.environment}-k8-worker-lc-1c-"
  security_groups             = ["${aws_security_group.k8-worker.id}"]
  user_data_base64            = "${base64encode(local.k8-worker-userdata-1c)}"
  key_name                    = "${var.key_name}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8-worker-asg-1c" {
  count                = "${var.create_az_based_workers}"
  desired_capacity     = "${var.desired_capacity_ondemand}"
  launch_configuration = "${aws_launch_configuration.k8-worker-lc-1c.id}"
  max_size             = "${var.max_size_ondemand}"
  min_size             = "${var.min_size_ondemand}"
  termination_policies = ["OldestInstance"]
  name                 = "${var.environment}-k8-worker-1c"
  vpc_zone_identifier  = ["${var.aws_private_subnet_id_1c}"]

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-1c"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Team"
    value               = "${var.team_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.team_owner}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["desired_capacity"]
  }
}
