# Contributing

Details below apply to all Terraform modules in this project (currently `aws/modules/infrastructure` and `kubernetes/modules/meltano`).

## Setup

This project relies on several tools to lint, format and validate `.tf` files and to generate `README.md` files for each module:

- Terraform, currently version >1.0.5, installable from [here](https://www.terraform.io)
- `tflint`, installable from [here](https://github.com/terraform-linters/tflint).
- Linting, formatting and validation is done automatically using git `pre-commit`, installable from [here](https://pre-commit.com/#install).
- `README.md` generation requires `terraform-docs`, installable from [here](https://github.com/terraform-docs/terraform-docs).

## Generating Docs

To update each modules `README.md` after making changes, we must run `terraform-docs`. E.g.

```sh
cd aws/modules/infrastructure
terraform-docs .
```

This will replace the readme file at `aws/modules/infrastructure/README.md` with any changes made to the module and header docs.
