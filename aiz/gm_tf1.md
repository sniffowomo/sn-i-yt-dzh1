# Terraform Cheatsheet for Production Environments

This cheatsheet provides a quick reference for essential Terraform commands and concepts used in production environments.

## Core Commands

| Command | Description |
| :--- | :--- |
| `terraform init` | Initializes a new or existing Terraform configuration in the current directory. Downloads provider plugins and sets up the backend. |
| `terraform plan` | Creates an execution plan. It's a dry run that shows what Terraform will do without actually making any changes. |
| `terraform apply` | Applies the changes required to reach the desired state of the configuration. It will create, update, or destroy resources. |
| `terraform destroy` | Destroys all the resources managed by the Terraform configuration. Use with caution. |

### Command Options

- `terraform plan -out=tfplan` - Saves the execution plan to a file.
- `terraform apply "tfplan"` - Applies a saved plan file.
- `terraform apply -auto-approve` - Skips the interactive approval of the plan. Not recommended in production.
- `terraform destroy -auto-approve` - Skips the interactive approval for destruction. Not recommended in production.

## State Management

Terraform keeps track of the resources it manages in a state file. It's crucial to manage this file carefully.

| Command | Description |
| :--- | :--- |
| `terraform state list` | Lists all resources in the state file. |
| `terraform state show <resource_address>` | Shows the details of a specific resource in the state. |
| `terraform state mv <source> <destination>` | Moves a resource from one address to another in the state file. Useful for renaming resources or moving them to modules. |
| `terraform state rm <resource_address>` | Removes a resource from the state file. This does not destroy the resource itself. |
| `terraform import <resource_address> <provider_id>`| Imports an existing resource into the Terraform state. |

**Example:**
```bash
# Move a resource to a new address
terraform state mv 'aws_instance.web_server' 'module.web_app.aws_instance.web_server'
```

## Workspaces

Workspaces allow you to manage multiple environments (e.g., staging, production) with the same Terraform configuration.

| Command | Description |
| :--- | :--- |
| `terraform workspace new <name>` | Creates a new workspace. |
| `terraform workspace select <name>` | Selects a workspace. |
| `terraform workspace list` | Lists all existing workspaces. |
| `terraform workspace delete <name>`| Deletes a workspace. |

**Example:**
```bash
# Create and select a production workspace
terraform workspace new production
terraform workspace select production
```

## Formatting and Validation

| Command | Description |
| :--- | :--- |
| `terraform fmt -recursive` | Formats all Terraform configuration files in the current directory and subdirectories to a canonical format. |
| `terraform validate` | Validates the syntax of the Terraform files. |

## Providers

Providers are plugins that Terraform uses to interact with cloud providers, SaaS providers, and other APIs.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
```

## Resources

Resources are the most important element in Terraform. They describe one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components.

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
```

## Variables

### Input Variables

Input variables serve as parameters for a Terraform module, allowing aspects of the module to be customized without altering the module's own source code.

**`variables.tf`**
```hcl
variable "instance_type" {
  description = "The type of instance to start."
  type        = string
  default     = "t2.micro"
}
```

**`terraform.tfvars`**
```hcl
instance_type = "t3.small"
```

### Output Variables

Output values are like the return values of a Terraform module.

**`outputs.tf`**
```hcl
output "instance_ip_addr" {
  value = aws_instance.web_server.public_ip
}
```

## Modules

A Terraform module is a set of Terraform configuration files in a single directory. Even a simple configuration with a single `main.tf` file is a module.

**Project Structure:**
```
.
├── main.tf
├── variables.tf
└── modules/
    └── web_app/
        ├── main.tf
        └── variables.tf
```

**`main.tf`**
```hcl
module "web_app" {
  source        = "./modules/web_app"
  instance_type = "t2.micro"
}
```

## Expressions and Functions

| Function | Description |
| :--- | :--- |
| `lookup(map, key, default)` | Retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned. |
| `length(list)` | Returns the number of elements in a list. |
| `cidrsubnet(prefix, newbits, netnum)` | Calculates a subnet address within a given IP network address prefix. |
| `join(separator, list)` | Joins the elements of a list with a given separator. |
| `file(path)` | Reads the contents of a file at the given path and returns them as a string. |

**Example:**
```hcl
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer-${count.index}"
  }
}
```

This cheatsheet covers the fundamentals for using Terraform in a production setting. For more in-depth information, refer to the official [Terraform documentation](https://www.terraform.io/docs/index.html).
