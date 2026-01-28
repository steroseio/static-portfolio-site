locals {
  common_tags = merge(
    {
      tf_managed = "true"
      project    = var.project_name
    },
    var.tags,
  )
}
