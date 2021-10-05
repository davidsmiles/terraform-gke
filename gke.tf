variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke-demo"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# GKE Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  cluster  = google_container_cluster.primary.name
  name     = "my-node-pool"
  location = var.region

  node_count = var.gke_num_nodes
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = true
    machine_type = "e2-medium"

    tags = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}