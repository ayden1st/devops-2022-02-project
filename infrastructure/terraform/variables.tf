variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "disk_image" {
  description = "Disk image"
  default     = "ubuntu-1804-lts"
}
variable "service_account_key_file" {
  description = "key_tf.json"
}
variable "service_account_id" {
  description = "Service account to be used for provisioning Compute Cloud and VPC resources for Kubernetes cluster"
}
variable "node_service_account_id" {
  description = "Service account to be used by the worker nodes of the Kubernetes cluster to access Container Registry or to push node logs and metrics."
}
variable "k8s_version" {
  description = "Kubernetes version"
  default     = "1.19"
}
variable "count_of_instances" {
  description = "Count of k8s instances"
  default     = 1
}
variable "cores" {
  description = "Core number for instance"
  default     = 4
}
variable "memory" {
  description = "Memory GB for instance"
  default     = 8
}
variable "disk_size" {
  description = "OS disk size"
  default     = 64
}
