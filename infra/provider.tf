provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "terraform"
      Purpose   = "log-generation"
    }
  }
}

# 가용영역 조회 (a or a, b or .... a,b,c,d)
data "aws_availability_zones" "available" {
  state = "available"
}
