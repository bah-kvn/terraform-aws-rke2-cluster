# describe available recipes
help:
  just --list --unsorted

# configure use of the .githooks directory
add-hooks:
  git config core.hooksPath .github/hooks

# update the README
@generate-docs:
  command -v terraform-docs > /dev/null || { echo 'you need to install terraform-docs'; exit 1; }
  @terraform-docs .

# lint with tflint
@tflint:
  command -v tflint > /dev/null || { echo 'you need to install tflint'; exit 1; }
  @tflint --init
  @tflint . 

# run static code analysis with tfsec
@tfsec:
  command -v tfsec > /dev/null || { echo 'you need to install tfsec'; exit 1; }
  @tfsec .

# runs terraform fmt to format code
tf-fmt:
  terraform fmt

# runs terraform init to download dependencies
tf-init:
  terraform init

# runs terraform validate
tf-validate: tf-init
  terraform validate

# execute all the things
ci: tf-fmt tf-validate generate-docs tflint tfsec