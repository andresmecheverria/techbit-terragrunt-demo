variable "project" {
  type        = string
  description = "Project id label"
}
variable "domain" {
  type        = string
  description = "Input domain development team"
}
variable "env" {
  type        = string
  description = "Targe environment short id"
}
variable "location_name" {
  type        = string
  description = "Input location name for deployment"
}
variable "tags" {
  type        = map(string)
  description = "This are the input tags for deployment"
}