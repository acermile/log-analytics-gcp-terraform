resource "google_logging_project_sink" "instance-sink-to-pub-sub" {
  name        = "log-anallytics-to-pub-sub-sink"
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${var.environment}_log_sink_topic"
  filter      = "resource.type = gce_instance AND log_id(\"purchase-log\") AND resource.labels.instance_id = \"${google_compute_instance.application.instance_id}\""

  unique_writer_identity = true
}


# Because our sink uses a unique_writer, we must grant that writer access.
resource "google_project_iam_binding" "log-writer-pub-sub" {
  role = "roles/pubsub.editor"

  members = [
    google_logging_project_sink.instance-sink-to-pub-sub.writer_identity,
  ]
}

// cloud pub-sub topic for streaming to Log aggregator platform like ELK
resource "google_pubsub_topic" "log-sink-topic" {
  name = "${var.environment}_log_sink_topic"

  labels = {
    env = var.environment
  }
}
