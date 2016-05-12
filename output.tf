output "couchbase_node1_private_ip" {
    value = "${aws_instance.couchbase_cluster_node1.private_ip}"
}

output "couchbase_node2_private_ip" {
    value = "${aws_instance.couchbase_cluster_node2.private_ip}"
}

output "couchbase_node3_private_ip" {
    value = "${aws_instance.couchbase_cluster_node3.private_ip}"
}