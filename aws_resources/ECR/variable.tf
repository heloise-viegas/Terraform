variable "ecr_name" {
    type =string
}

variable "ecr_tag" {
    type =string
}

variable "image_tag_mutability" {
default = "MUTABLE"
}

variable "scan_on_push" {
    default = true
}
