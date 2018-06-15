module "ecs" {
  source = "../modules/ecs"
  app_version = "1.0"
  asg_desired = "4"
}

