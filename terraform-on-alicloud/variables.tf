variable "access_key" {
    description = "Access key of alicloud"
}
variable "access_secret" {
  description = "Access secret of alicloud"
}

variable "image-id" {
    description = "Disk Image ID for ECS boot disk: Ubuntu 18.X"
    default = "ubuntu_20_04_x64_20G_alibase_20210623.vhd"
}

variable "region" {
  default = "ap-south-1"
}