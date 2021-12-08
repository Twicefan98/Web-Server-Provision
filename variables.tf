variable "public_key" {
  type    = string
  default = "~/.ssh/MyKeyPair.pub"
}

variable "private_key" {
  type    = string
  default = "~/.ssh/MyKeyPair.pem"
}