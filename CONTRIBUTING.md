# Contributing

## Recommended IDE Setup

Our team uses [VS Code](https://code.visualstudio.com/) to terraform development.

Recommended spellers:

* [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
* [Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
* [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
* [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
* [Just](https://marketplace.visualstudio.com/items?itemName=skellock.just)

## Justfile

We use [Just](https://github.com/casey/just) to orchestrate common actions.

To see the full list of available recipes, run

> just help

## Git Hooks

To automatically run the checks defined below as a pre-commit hook locally, run

> just add-hooks

The pre-commit hook will execute

> just ci

which triggers all checks outlined below.

## Linting

### terraform fmt

The built-in command `terraform fmt` will automatically reformat the code in alignment with terraform conventions.

> just tf-fmt

### terraform validate

The built-in command `terraform validate` will do some basic static code analysis of the tf files.

> just tf-validate

### tflint

[tflint](https://github.com/terraform-linters/tflint) is used to ensure consistency and adherence to terraform best practices.

We configure the following rule sets:

* [terraform](https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.1.1/docs/rules/README.md)
* [aws](https://github.com/terraform-linters/tflint-ruleset-aws/blob/v0.17.1/docs/rules/README.md)

These rule sets are added via plugins, configured in the [`.tflint.hcl`](./.tflint.hcl) file.

You can execute tflint by running:

> just tflint

## tfsec

We use [tfsec](https://github.com/aquasecurity/tfsec) for static code analysis to ensure we're deploying secure infrastructure.

You can execute tfsec by running:

> just tfsec

## Documentation

The README documentation is automatically generated using [terraform-docs](https://terraform-docs.io/user-guide/introduction/).

You can find the configuration for terraform-docs in the [`.terraform-docs.yaml`](./.terraform-docs.yaml) file.

You can update the README by running:

> just generate-docs
