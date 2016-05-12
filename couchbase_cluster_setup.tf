provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "couchbase_cluster_node1" {
    ami = "ami-e018258a"
    instance_type = "t2.micro"
    key_name = "vexierekeypair-verginia"
    tags {
        Name = "couchbase_cluster_node1"
    }
}

resource "aws_instance" "couchbase_cluster_node2" {
    ami = "ami-e018258a"
    instance_type = "t2.micro"
    key_name = "vexierekeypair-verginia"
    tags {
        Name = "couchbase_cluster_node2"
    }
}

resource "aws_instance" "couchbase_cluster_node3" {
    ami = "ami-e018258a"
    instance_type = "t2.micro"
    key_name = "vexierekeypair-verginia"
    tags {
        Name = "couchbase_cluster_node3"
    }
}


resource "null_resource" "couchbase_cluster_formation" {  
    triggers {
      couchbase_node1_public_ip = "${aws_instance.couchbase_cluster_node1.public_ip}"
      couchbase_node1_private_ip = "${aws_instance.couchbase_cluster_node1.private_ip}"
      couchbase_node2_private_ip = "${aws_instance.couchbase_cluster_node2.private_ip}"
      couchbase_node3_private_ip = "${aws_instance.couchbase_cluster_node3.private_ip}"
    } 

    provisioner "remote-exec" {
             connection {
              type = "ssh"
              user = "ubuntu"
              host = "${aws_instance.couchbase_cluster_node1.public_ip}"
              private_key = "${file(".\vexierekeypair-verginia.pem")}"
            }

            inline = [
            "sleep 10",
            "/opt/couchbase/bin/couchbase-cli setting-cluster --cluster-name couchbase_vexiere_cluster --cluster-ramsize=${var.cluster_ram_quota} -c 127.0.0.1:8091 -u ${var.admin_user} -p ${var.admin_password}",
            "/opt/couchbase/bin/couchbase-cli cluster-edit -c ${aws_instance.couchbase_cluster_node1.private_ip}:8091 -u ${var.admin_user} -p ${var.admin_password} --services=data,index,query",
            "/opt/couchbase/bin/couchbase-cli server-add -c 127.0.0.1:8091 -u ${var.admin_user} -p ${var.admin_password} --server-add=${aws_instance.couchbase_cluster_node2.private_ip}:8091 --server-add-username=${var.admin_user} --server-add-password=${var.admin_password} --services=data,index,query",        
            "/opt/couchbase/bin/couchbase-cli server-add -c 127.0.0.1:8091 -u ${var.admin_user} -p ${var.admin_password} --server-add=${aws_instance.couchbase_cluster_node3.private_ip}:8091 --server-add-username=${var.admin_user} --server-add-password=${var.admin_password} --services=data,index,query",
            "/opt/couchbase/bin/couchbase-cli rebalance -c 127.0.0.1:8091 -u ${var.admin_user} -p ${var.admin_password}",
            "/opt/couchbase/bin/couchbase-cli bucket-create -c 127.0.0.1:8091 -u ${var.admin_user} -p ${var.admin_password} --bucket=${var.couchbase_default_bucket_name} --bucket-type=couchbase --bucket-port=11211 --bucket-ramsize=${var.bucket_ram_quota} --bucket-replica=${var.couchbase_default_replicas}" 
            ]
        }
}