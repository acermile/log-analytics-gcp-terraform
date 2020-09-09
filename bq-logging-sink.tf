resource "google_logging_project_sink" "instance-sink-to-bq" {
  name        = "${var.environment}-log-anallytics-to-bq-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.purchase-logs.dataset_id}"
  filter      = "resource.type = gce_instance AND log_id(\"purchase-log\") AND resource.labels.instance_id = \"${google_compute_instance.application.instance_id}\""

  unique_writer_identity = true
}


# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log-writer" {
  role = "roles/bigquery.dataOwner"

  members = [
    google_logging_project_sink.instance-sink-to-bq.writer_identity,
  ]
}


//dataset creattion for sink
resource "google_bigquery_dataset" "purchase-logs" {
  dataset_id    = "${var.environment}_purchase_logs"
  friendly_name = "${var.environment}_purchase_logs"
  description   = "Log analytics"
  //  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = var.environment
  }

  /*   access {
    role          = "OWNER"
    user_by_email = "aarav.shar12@gmail.com"
  }

  access {
    role   = "READER"
    domain = "hashicorp.com"
  } */
}

/*resource "google_service_account" "bqowner" {
  account_id = "bqowner"
} */

resource "google_bigquery_table" "uk-purchase" {
  dataset_id = google_bigquery_dataset.purchase-logs.dataset_id
  table_id   = "${var.environment}_uk_purchases_${random_string.suffix.result}_table"
}

resource "google_bigquery_job" "job" {
  job_id = "${var.environment}_uk_purchases_${random_string.suffix.result}_job_query"

  labels = {
    "product" = "value"
  }

  query {
    query = "SELECT textPayload FROM `cloudarchitectexam.purchase_logs.purchase_log_20200909` where textPayload like '%United Kingdom%' LIMIT 1000"

    destination_table {
      project_id = var.project_id
      dataset_id = google_bigquery_dataset.purchase-logs.dataset_id
      table_id   = google_bigquery_table.uk-purchase.table_id
    }

    allow_large_results = true
    flatten_results     = true

    write_disposition = "WRITE_TRUNCATE"

    script_options {
      key_result_statement = "LAST"
    }
  }
}

resource "random_string" "suffix" {
  length  = 3
  special = false
}
