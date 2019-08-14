locals {
  k8-worker-spot-system-userdata-1a = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2Spot,az=1a,nodeType=systemNode' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
USERDATA

  k8-worker-spot-system-userdata-1b = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2Spot,az=1b,nodeType=systemNode' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
USERDATA

  k8-worker-spot-system-userdata-1c = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --kubelet-extra-args --node-labels='lifecycle=Ec2Spot,az=1c,nodeType=systemNode' --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster-name}' --kube-reserved 'cpu=250m,memory=1Gi,ephemeral-storage=1Gi' --system-reserved 'cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi' --eviction-hard 'memory.available<1Gi,nodefs.available<10%'
USERDATA
}

##### AVAILABILITY ZONE 1A #####

resource "aws_launch_template" "k8-worker-spot-system-lt-1a" {
  count       = "${var.create_spot_workers}"
  name_prefix = "${var.environment}-k8-worker-spot-system-lt-1a"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.k8-worker.name}"
  }

  image_id               = "${var.aws_image_id}"
  instance_type          = "r4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.k8-worker.id}"]
  user_data              = "${base64encode(local.k8-worker-spot-system-userdata-1a)}"
  key_name               = "${var.key_name}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp2"
      volume_size = 100
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${local.tags}"
}

resource "aws_autoscaling_group" "k8-worker-spot-system-asg-1a" {
  count               = "${var.create_spot_workers}"
  desired_capacity    = "${var.desired_capacity_spot}"
  max_size            = "${var.max_size_spot}"
  min_size            = "${var.min_size_spot}"
  name                = "${var.environment}-k8-worker-spot-system-1a"
  vpc_zone_identifier = ["${var.aws_private_subnet_id_1a}"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
      spot_max_price                           = 0.2
      spot_allocation_strategy                 = "lowest-price" # The only valid value is lowest-price, which is also the default value. The Auto Scaling group selects the cheapest Spot pools and evenly allocates your Spot capacity across the number of Spot pools that you specify
    }

    launch_template {
      launch_template_specification {
        version            = "$$Latest"
        launch_template_id = "${aws_launch_template.k8-worker-spot-system-lt-1a.id}"
      }

      override {
        instance_type = "r4.xlarge"
      }

      override {
        instance_type = "m4.xlarge"
      }

      # override {
      #   instance_type = "m4.large"
      # }

      # override {
      #   instance_type = "t3.large"
      # }

      # override {
      #   instance_type = "t2.large"
      # }

      # override {
      #   instance_type = "c5.xlarge"
      # }

      # override {
      #   instance_type = "c5d.xlarge"
      # }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-system-spot-1a"
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

########################################################################################

##### AVAILABILITY ZONE 1B #####

resource "aws_launch_template" "k8-worker-spot-system-lt-1b" {
  count       = "${var.create_spot_workers}"
  name_prefix = "${var.environment}-k8-worker-spot-system-lt-1b"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.k8-worker.name}"
  }

  image_id               = "${var.aws_image_id}"
  instance_type          = "r4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.k8-worker.id}"]
  user_data              = "${base64encode(local.k8-worker-spot-system-userdata-1b)}"
  key_name               = "${var.key_name}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp2"
      volume_size = 100
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${local.tags}"
}

resource "aws_autoscaling_group" "k8-worker-spot-system-asg-1b" {
  count               = "${var.create_spot_workers}"
  desired_capacity    = "${var.desired_capacity_spot}"
  max_size            = "${var.max_size_spot}"
  min_size            = "${var.min_size_spot}"
  name                = "${var.environment}-k8-worker-spot-system-1b"
  vpc_zone_identifier = ["${var.aws_private_subnet_id_1b}"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
      spot_max_price                           = 0.2
      spot_allocation_strategy                 = "lowest-price" # The only valid value is lowest-price, which is also the default value. The Auto Scaling group selects the cheapest Spot pools and evenly allocates your Spot capacity across the number of Spot pools that you specify
    }

    launch_template {
      launch_template_specification {
        version            = "$$Latest"
        launch_template_id = "${aws_launch_template.k8-worker-spot-system-lt-1b.id}"
      }

      override {
        instance_type = "r4.xlarge"
      }

      override {
        instance_type = "m4.xlarge"
      }

      # override {
      #   instance_type = "m4.large"
      # }

      # override {
      #   instance_type = "t3.large"
      # }

      # override {
      #   instance_type = "t2.large"
      # }

      # override {
      #   instance_type = "c5.xlarge"
      # }

      # override {
      #   instance_type = "c5d.xlarge"
      # }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-system-spot-1b"
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

########################################################################################

##### AVAILABILITY ZONE 1C #####

resource "aws_launch_template" "k8-worker-spot-system-lt-1c" {
  count       = "${var.create_spot_workers}"
  name_prefix = "${var.environment}-k8-worker-spot-system-lt-1c"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.k8-worker.name}"
  }

  image_id               = "${var.aws_image_id}"
  instance_type          = "r4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.k8-worker.id}"]
  user_data              = "${base64encode(local.k8-worker-spot-system-userdata-1c)}"
  key_name               = "${var.key_name}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp2"
      volume_size = 100
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${local.tags}"
}

resource "aws_autoscaling_group" "k8-worker-spot-system-asg-1c" {
  count               = "${var.create_spot_workers}"
  desired_capacity    = "${var.desired_capacity_spot}"
  max_size            = "${var.max_size_spot}"
  min_size            = "${var.min_size_spot}"
  name                = "${var.environment}-k8-worker-spot-system-1c"
  vpc_zone_identifier = ["${var.aws_private_subnet_id_1c}"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
      spot_max_price                           = 0.2
      spot_allocation_strategy                 = "lowest-price" # The only valid value is lowest-price, which is also the default value. The Auto Scaling group selects the cheapest Spot pools and evenly allocates your Spot capacity across the number of Spot pools that you specify
    }

    launch_template {
      launch_template_specification {
        version            = "$$Latest"
        launch_template_id = "${aws_launch_template.k8-worker-spot-system-lt-1c.id}"
      }

      override {
        instance_type = "r4.xlarge"
      }

      override {
        instance_type = "m4.xlarge"
      }

      # override {
      #   instance_type = "m4.large"
      # }

      # override {
      #   instance_type = "t3.large"
      # }

      # override {
      #   instance_type = "t2.large"
      # }

      # override {
      #   instance_type = "c5.xlarge"
      # }

      # override {
      #   instance_type = "c5d.xlarge"
      # }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-k8-worker-system-spot-1c"
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
