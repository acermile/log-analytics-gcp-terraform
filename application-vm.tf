resource "google_compute_instance" "application" {
  name         = "${var.environment}-application"
  machine_type = "n1-standard-1"
  //zone         = "us-central1-a"
  //project      = var.project_id
  tags = ["application", "logs"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["compute-ro", "storage-ro", "cloud-platform"]
  }
  metadata = {
    application = "log-analytics"
  }

  metadata_startup_script = file("log-agent.sh")

}
