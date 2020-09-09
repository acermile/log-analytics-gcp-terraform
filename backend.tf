terraform {

  backend "gcs" {
    bucket = "cloudarchitectbucket"
    prefix = "terraform/state/log-analytics"
  }
}
