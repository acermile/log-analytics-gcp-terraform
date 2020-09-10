# Serverless logging on GCP using Cloud logging agent, Log sink to Bigquery and Cloud Pub sub
<img src="/gcp-logs.png" width="100%" alt="gcp-logs" title="gcp-logs">



Terraform will perform the following actions:

  # google_bigquery_dataset.purchase-logs will be created
  + resource "google_bigquery_dataset" "purchase-logs" {
      + creation_time               = (known after apply)
      + dataset_id                  = "qa_purchase_logs"
      + default_table_expiration_ms = 3600000
      + delete_contents_on_destroy  = false
      + description                 = "Log analytics"
      + etag                        = (known after apply)
      + friendly_name               = "qa_purchase_logs"
      + id                          = (known after apply)
      + labels                      = {
          + "env" = "qa"
        }
      + last_modified_time          = (known after apply)
      + location                    = "US"
      + project                     = (known after apply)
      + self_link                   = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_bigquery_job.job will be created
  + resource "google_bigquery_job" "job" {
      + id         = (known after apply)
      + job_id     = (known after apply)
      + job_type   = (known after apply)
      + labels     = {
          + "product" = "value"
        }
      + location   = "US"
      + project    = (known after apply)
      + user_email = (known after apply)

      + query {
          + allow_large_results = true
          + create_disposition  = "CREATE_IF_NEEDED"
          + flatten_results     = true
          + priority            = "INTERACTIVE"
          + query               = "SELECT textPayload FROM `cloudarchitectexam.purchase_logs.purchase_log_20200909` where textPayload like '%United Kingdom%' LIMIT 1000"
          + use_query_cache     = true
          + write_disposition   = "WRITE_TRUNCATE"

          + destination_table {
              + dataset_id = "qa_purchase_logs"
              + project_id = "cloudarchitectexam"
              + table_id   = (known after apply)
            }

          + script_options {
              + key_result_statement = "LAST"
            }
        }
    }

  # google_bigquery_table.uk-purchase will be created
  + resource "google_bigquery_table" "uk-purchase" {
      + creation_time       = (known after apply)
      + dataset_id          = "qa_purchase_logs"
      + etag                = (known after apply)
      + expiration_time     = (known after apply)
      + id                  = (known after apply)
      + last_modified_time  = (known after apply)
      + location            = (known after apply)
      + num_bytes           = (known after apply)
      + num_long_term_bytes = (known after apply)
      + num_rows            = (known after apply)
      + project             = (known after apply)
      + schema              = (known after apply)
      + self_link           = (known after apply)
      + table_id            = (known after apply)
      + type                = (known after apply)
    }

  # google_compute_instance.application will be created
  + resource "google_compute_instance" "application" {
      + can_ip_forward          = false
      + cpu_platform            = (known after apply)
      + current_status          = (known after apply)
      + deletion_protection     = false
      + guest_accelerator       = (known after apply)
      + id                      = (known after apply)
      + instance_id             = (known after apply)
      + label_fingerprint       = (known after apply)
      + machine_type            = "n1-standard-1"
      + metadata                = {
          + "application" = "log-analytics"
        }
      + metadata_fingerprint    = (known after apply)
      + metadata_startup_script = <<~EOT
            sudo curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
            sudo bash add-logging-agent-repo.sh

            sudo apt-get update
            sudo apt-get install -y zip

            sudo apt-get install -y google-fluentd
            sudo apt-get install -y google-fluentd-catch-all-config
            sudo service google-fluentd start
            sudo tee /etc/google-fluentd/config.d/purchase-log.conf <<EOF
            <source>
            @type tail
                # Format 'none' indicates the log is unstructured (text).
            format none
                # The path of the log file.
            path /var/log/cadabra/*.log
                # The path of the position file that records where in the log file
                # we have processed already. This is useful when the agent
                # restarts.
            pos_file /var/lib/google-fluentd/pos/test-unstructured-log.pos
            read_from_head true
                # The log tag for this log input.
            tag purchase-log
            </source>
            EOF

            sudo service google-fluentd restart
            wget http://media.sundog-soft.com/AWSBigData/LogGenerator.zip
            unzip LogGenerator.zip
            chmod a+x LogGenerator.py
            sudo mkdir /var/log/cadabra
            sudo ./LogGenerator.py 50000
        EOT
      + min_cpu_platform        = (known after apply)
      + name                    = "qa-application"
      + project                 = (known after apply)
      + self_link               = (known after apply)
      + tags                    = [
          + "application",
          + "logs",
        ]
      + tags_fingerprint        = (known after apply)
      + zone                    = (known after apply)

      + boot_disk {
          + auto_delete                = true
          + device_name                = (known after apply)
          + disk_encryption_key_sha256 = (known after apply)
          + kms_key_self_link          = (known after apply)
          + mode                       = "READ_WRITE"
          + source                     = (known after apply)

          + initialize_params {
              + image  = "debian-cloud/debian-9"
              + labels = (known after apply)
              + size   = (known after apply)
              + type   = (known after apply)
            }
        }

      + network_interface {
          + name               = (known after apply)
          + network            = "default"
          + network_ip         = (known after apply)
          + subnetwork         = (known after apply)
          + subnetwork_project = (known after apply)

          + access_config {
              + nat_ip       = (known after apply)
              + network_tier = (known after apply)
            }
        }

      + scheduling {
          + automatic_restart   = (known after apply)
          + on_host_maintenance = (known after apply)
          + preemptible         = (known after apply)

          + node_affinities {
              + key      = (known after apply)
              + operator = (known after apply)
              + values   = (known after apply)
            }
        }

      + service_account {
          + email  = (known after apply)
          + scopes = [
              + "https://www.googleapis.com/auth/cloud-platform",
              + "https://www.googleapis.com/auth/compute.readonly",
              + "https://www.googleapis.com/auth/devstorage.read_only",
            ]
        }
    }

  # google_logging_project_sink.instance-sink-to-bq will be created
  + resource "google_logging_project_sink" "instance-sink-to-bq" {
      + destination            = "bigquery.googleapis.com/projects/cloudarchitectexam/datasets/qa_purchase_logs"
      + filter                 = (known after apply)
      + id                     = (known after apply)
      + name                   = "qa-log-anallytics-to-bq-sink"
      + project                = (known after apply)
      + unique_writer_identity = true
      + writer_identity        = (known after apply)

      + bigquery_options {
          + use_partitioned_tables = (known after apply)
        }
    }

  # google_logging_project_sink.instance-sink-to-pub-sub will be created
  + resource "google_logging_project_sink" "instance-sink-to-pub-sub" {
      + destination            = "pubsub.googleapis.com/projects/cloudarchitectexam/topics/qa_log_sink_topic"
      + filter                 = (known after apply)
      + id                     = (known after apply)
      + name                   = "log-anallytics-to-pub-sub-sink"
      + project                = (known after apply)
      + unique_writer_identity = true
      + writer_identity        = (known after apply)

      + bigquery_options {
          + use_partitioned_tables = (known after apply)
        }
    }

  # google_project_iam_binding.log-writer will be created
  + resource "google_project_iam_binding" "log-writer" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = (known after apply)
      + project = (known after apply)
      + role    = "roles/bigquery.dataOwner"
    }

  # google_project_iam_binding.log-writer-pub-sub will be created
  + resource "google_project_iam_binding" "log-writer-pub-sub" {
      + etag    = (known after apply)
      + id      = (known after apply)
      + members = (known after apply)
      + project = (known after apply)
      + role    = "roles/pubsub.editor"
    }

  # google_pubsub_topic.log-sink-topic will be created
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

  # random_string.suffix will be created
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
