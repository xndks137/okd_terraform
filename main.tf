module "iam" {
  source = "./modules/IAM"
  cluster_name = "okd4"
}

module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  region = var.region
  dns_servers = var.dns_servers
}

module "instances" {
  source = "./modules/instances"
  vpc_id = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  manager_ip = var.manager_ip
  lb_ip = var.lb_ip
  dns_ip = var.dns_ip
  bootstrap_ip = var.bootstrap_ip
  control_plane_ips = var.control_plane_ips
  worker_ips = var.worker_ips
  pub_sg = module.network.pub_sg_id
  bootstrap_sg = module.network.bootstrap_sg_id
  master_sg = module.network.master_sg_id
  worker_sg = module.network.worker_sg_id
  RHCOS = var.RHCOS
  AL2023 = var.AL2023
  key_name = var.key_name
  pullSecret = var.pullSecret
  bootstrap_iam = module.iam.bootstrap_instance_profile_name
  master_iam = module.iam.master_instance_profile_name
  worker_iam = module.iam.worker_instance_profile_name
  instance_type = var.instance_type
}

module "route53" {
  source = "./modules/route53"
  cluster_name = var.cluster_name
  zone_id = var.zone_id
  zone_name = var.zone_name
  lb_public_ip = module.instances.lb_public_ip
}

