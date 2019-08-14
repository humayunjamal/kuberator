data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "net" {
  id = "vpc-XXXX"
}

# Comment this block if subnets do not exist
data "aws_subnet_ids" "net_private" {
  vpc_id = "${data.aws_vpc.net.id}"

  tags {
    Name = "private-*"
  }
}

# Comment this block if subnets do not exist
data "aws_subnet_ids" "net_public" {
  vpc_id = "${data.aws_vpc.net.id}"

  tags {
    Name = "public-*"
  }
}

data "aws_ami" "k8-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.13*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}
