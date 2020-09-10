# Serverless logging on GCP using Cloud logging agent, Log sink to Bigquery and Cloud Pub sub
<img src="/gcp-logs.png" width="100%" alt="gcp-logs" title="gcp-logs">



Terraform will perform the following actions:

................................................

   google_project_iam_binding.log-writer-pub-sub will be created
  + resource "google_project_iam_binding" "log-writer-pub-sub" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = (known after apply)
      + project = (known after apply)
      + role    = "roles/pubsub.editor"
    }

  google_pubsub_topic.log-sink-topic will be created
  + resource "google_pubsub_topic" "log-sink-topic" {
      + id      = (known after apply)
      + labels  = {
          + "env" = "qa"
        }
      + name    = "qa_log_sink_topic"
      + project = (known after apply)

      + message_storage_policy {
          + allowed_persistence_regions = (known after apply)
        }
    }

   random_string.suffix will be created
  + resource "random_string" "suffix" {
      + id          = (known after apply)
      + length      = 3
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = false
      + upper       = true
    }

Plan: 10 to add, 0 to change, 0 to destroy.
