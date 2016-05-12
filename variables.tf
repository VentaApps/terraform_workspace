variable "access_key" {}
variable "secret_key" {}
variable "admin_password" {}
variable "region" {
    default = "us-east-1"
}
variable "admin_user" {
    default = "Administrator"
}
variable "cluster_ram_quota" {
    default = "500"
}
variable "bucket_ram_quota" {
    default = "400"
}
variable "couchbase_default_bucket_name" {
    default = "vexiere"
}
variable "couchbase_default_replicas" {
    default = "1"
}