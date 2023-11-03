
variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

# Create an output "upper_names" to store the uppercase versions of names in the "names" list
output "upper_names" {
  value = [for name in var.names : upper(name)]
}

# Create an output "short_upper_names" to store uppercase names with a length less than 5 characters
output "short_upper_names" {
  value = [for name in var.names : upper(name) if length(name) < 5]
}

# Define a variable "hero_thousand_faces" as a map with default values
variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default     = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "mentor"
  }
}

# Create an output "bios" to generate descriptions of characters and their roles
output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}

# Create an output "upper_roles" to generate uppercase versions of character names and roles
output "upper_roles" {
  value = {for name, role in var.hero_thousand_faces : upper(name) => upper(role)}
}
