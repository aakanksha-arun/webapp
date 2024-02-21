variable "project_id" {
  type = string
  default = "dev-alijahh"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "source_image_family" {
  type = string
  default = "centos-stream-8"
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "image_name" {
  type    = string
  default = "csye6225-{{timestamp}}"
}

variable "image_description" {
  type    = string
  default = "CSYE 6225 APP Custom Image at {{timestamp}}"
}

variable "image_family" {
  type    = string
  default = "csye6225-app-image"
}

variable "image_project_id" {
  type = string
  default = "dev-alijahh"
}

variable "image_storage_locations" {
  type    = list(string)
  default = ["us"]
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "zip_source" {
  type    = string
  default = "webapp.zip"
}

variable "setup_script" {
  type    = string
  default = "setup.sh"
}

variable "systemd_script" {
  type    = string
  default = "systemd.sh"
}

variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_user" {
  type    = string
  default = "a"
}

variable "db_pass" {
  type    = string
  default = "abc"
}

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "my-custom-image" {
  project_id              = var.project_id
  source_image_family     = var.source_image_family
  zone                    = var.zone
  disk_size               = var.disk_size
  disk_type               = var.disk_type
  image_name              = var.image_name
  image_description       = var.image_description
  image_family            = var.image_family
  image_project_id        = var.image_project_id
  image_storage_locations = var.image_storage_locations
  ssh_username            = var.ssh_username
}

build {
  sources = ["sources.googlecompute.my-custom-image"]

  provisioner "file" {
    source      = var.zip_source
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "db_user=${var.db_user}",
      "db_password=${var.db_pass}",
      "db_name=${var.db_name}"
    ]
    scripts = [
      var.setup_script,
      var.systemd_script
    ]
  }
}

