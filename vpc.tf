variable "project_id" {}

variable "region" {}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnetwork"
  network       = google_compute_network.vpc.name
  region        = var.region
  ip_cidr_range = "10.10.0.0/24"
}