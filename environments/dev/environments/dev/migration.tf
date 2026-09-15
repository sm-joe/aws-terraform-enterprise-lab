removed {
  from = module.vpc

  lifecycle {
    destroy = false
  }
}