
variable "vpc-cidr-block" {
  type    = string
  default = "10.0.0.0/16"

}


variable "public" {
  type    = string
  default = "apache-public-subnet"
}
variable "private" {
  type    = string
  default = "apache-private-subnet"
}

variable "ami" {

  type    = string
  default = "ami-0323d48d3a525fd18"

}