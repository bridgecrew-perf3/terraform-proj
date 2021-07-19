terraform { 
}

provider "alicloud" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.access_secret}"
}

data "alicloud_zones" "test_zones" {}

data "alicloud_instance_types" "core2mem4ghz" {
    memory_size = 4
    cpu_core_count = 2
    availability_zone="${data.alicloud_zones.test_zones.zones.0.id}"
}
resource "alicloud_vpc" "test_vpc" {
  vpc_name = "ecs-test-vps"
  cidr_block = "192.168.0.0/16"
}
resource "alicloud_vswitch" "test_vswitch" {
  vswitch_name = "ecs-test-vswitch"
  vpc_id = "${alicloud_vpc.test_vpc.id}"
  cidr_block = "192.168.0.0/24"
  zone_id = "${data.alicloud_zones.test_zones.zones.0.id}"
}

resource "alicloud_security_group" "test-sg" {
  name = "ecs-test-sg"
  vpc_id = "${alicloud_vpc.test_vpc.id}"
  description = "Webserver Security Groups"
}

resource "alicloud_security_group_rule" "http-in" {
  type = "ingress"
  ip_protocol = "tcp"
  policy = "accept"
  port_range = "80/80"
  security_group_id = "${alicloud_security_group.test-sg.id}"
  cidr_ip = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "ssh-in" {
  type = "ingress"
  ip_protocol = "tcp"
  policy = "accept"
  port_range = "22/22"
  security_group_id = "${alicloud_security_group.test-sg.id}"
  cidr_ip = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "icmp-in" {
  type = "ingress"
  ip_protocol = "icmp"
  policy = "accept"
  port_range = "-1/-1"
  security_group_id = "${alicloud_security_group.test-sg.id}"
  cidr_ip = "0.0.0.0/0"
}

resource "alicloud_key_pair" "ecs-test-ssh-key" {
    key_pair_name = "ecs-test-ssh-key"
    key_file = "ecs-test-ssh_key.pem"
}

resource "alicloud_instance" "test-instance" {
  instance_name = "ecs-test-instance"
  image_id = "${var.image-id}"
  instance_type = "${data.alicloud_instance_types.core2mem4ghz.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  user_data = "${file("install_apache.sh")}"
  security_groups = ["${alicloud_security_group.test-sg.id}"]
  vswitch_id = "${alicloud_vswitch.test_vswitch.id}"
  key_name = "${alicloud_key_pair.ecs-test-ssh-key.key_pair_name}"
  internet_max_bandwidth_out = 0
}
