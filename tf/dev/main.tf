variable "app_ver" {
  default = ""
}

module "ecs" {
  source = "../modules/ecs"
  app_version = "${var.app_ver}"
  asg_desired = "2"
}

