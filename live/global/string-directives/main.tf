

# Define a variable "names" with a description, type, and default values
variable "names" {
  description = "Names to render"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

# Create an output that iterates through the "names" variable and renders
# comma separated string
output "for_directive" {
  value = "%{ for name in var.names }${name}, %{ endfor }"
}

# Create output that iterates through the "names" variable rendering each name 
# with its index
output "for_directive_index" {
  value = "%{ for i, name in var.names }(${i}) ${name}, %{ endfor }"
}

# Create an output that iterates through "names", rendering names with
# conditional commas
output "for_directive_index_if" {
  value = <<EOF
%{ for i, name in var.names }
  ${name}%{ if i < length(var.names) - 1 }, %{ endif }
%{ endfor }
EOF
}

 
 
#(%{~ ... ~}) ensures that there are no extra spaces at the beginning/end



# Create an output that iterates through "names" variable, stripping leading/
# trailing whitespace
output "for_directive_index_if_strip" {
  value = <<EOF
%{~ for i, name in var.names ~}
${name}%{ if i < length(var.names) - 1 }, %{ endif }
%{~ endfor ~}
EOF
}

# Create an output that iterates through "names" using if-else conditional
# and stripping whitespace
output "for_directive_index_if_else_strip" {
  value = <<EOF
%{~ for i, name in var.names ~}
${name}%{ if i < length(var.names) - 1 }, %{ else }.%{ endif }
%{~ endfor ~}
EOF
}