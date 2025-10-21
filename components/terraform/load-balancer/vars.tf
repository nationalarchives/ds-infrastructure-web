variable "vpc_id" {
  description = "security group vpc id"
  type = string
}
variable "subnet_ids" {
  description = "Load-balancer private subnet ids"
  type = list(string)
}
variable "lb_cidr" {
  description = "cidr from which ingress is allowed"
  type = string
}
variable "tags" {
  type = map(string)
}
