Below is a **production‑ready Terraform cheatsheet**.  
It gathers the most‑used commands, file patterns, and best‑practice tips you’ll need to run Terraform safely at scale. Feel free to copy‑paste sections into your own docs or README.

---

## 1️⃣ Quick Reference Commands

| Action | Command | Notes |
|--------|---------|-------|
| Initialise a new or existing configuration | `terraform init` | Pulls providers, configures backend, installs modules |
| Show what will change | `terraform plan` | Add `-out=tfplan` to save the plan |
| Apply a saved plan | `terraform apply tfplan` | Guarantees you apply exactly what you reviewed |
| Apply directly (interactive) | `terraform apply` | Prompts for approval unless `-auto-approve` |
| Destroy all managed resources | `terraform destroy` | Use `-target` to limit scope |
| Refresh state from real infra | `terraform refresh` | Rarely needed – `plan` does it automatically |
| List resources in state | `terraform state list` | |
| Show detailed state for a resource | `terraform state show <address>` | |
| Move a resource to a new address | `terraform state mv <old> <new>` | |
| Import existing infra | `terraform import <address> <id>` | |
| Workspaces (env isolation) | `terraform workspace new <name>`<br>`terraform workspace select <name>`<br>`terraform workspace list` | Useful for dev/staging/prod when using a single backend |
| Validate configuration syntax | `terraform validate` | Runs locally, no provider calls |
| Format code | `terraform fmt` | Auto‑format HCL |
| Lint / static analysis | `terraform fmt -check`<br>`tflint` | Add to CI pipeline |
| Generate a dependency graph | `terraform graph | dot -Tpng > graph.png` | |

---

## 2️⃣ Project Layout (recommended)

```
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── backend.tf
│   │   └── terraform.tfvars
│   ├── prod/
│   │   ├── main.tf
│   │   ├── backend.tf
│   │   └── terraform.tfvars
│   └── staging/
│       └── …
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecs-service/
│   │   └── …
│   └── …
├── .terraform-version          # Pin Terraform version (tfenv, asdf, etc.)
├── .tflint.hcl                 # Linter config
├── .gitignore
└── README.md
```

* **`environments/`** – one folder per workspace (dev, prod, …). Keeps variable values and backend config separate.  
* **`modules/`** – reusable, version‑controlled building blocks.  
* **Pin Terraform & provider versions** (see §4).

---

## 3️⃣ Core HCL Snippets

### 3.1 Provider (example: AWS)

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
```

### 3.2 Variables & Types

```hcl
variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  validation {
    condition     = contains(["t3.micro","t3.small","t3.medium"], var.instance_type)
    error_message = "Allowed values: t3.micro, t3.small, t3.medium"
  }
}
```

### 3.3 Resources (example: EC2)

```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name        = "web-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
```

### 3.4 Data Sources

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

### 3.5 Outputs (sensitive handling)

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
  # Do NOT mark as sensitive unless you really need to hide it
}
```

### 3.6 Modules (calling)

```hcl
module "vpc" {
  source = "../../modules/vpc"

  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = terraform.workspace
  }
}
```

---

## 4️⃣ Production‑Grade Settings

| Concern | Recommended Setting |
|---------|----------------------|
| **Terraform version** | Pin in `required_version` and enforce via CI (e.g., `tfenv install 1.6.6 && tfenv use 1.6.6`) |
| **Provider version** | Use `~>` constraints; lock in `terraform.lock.hcl` (auto‑generated) |
| **Remote state backend** | S3 + DynamoDB lock (AWS) or Terraform Cloud/Enterprise. Enable **encryption at rest** and **in‑transit**. |
| **State encryption** | `encrypt = true` (S3) or default in Terraform Cloud |
| **State access control** | IAM policies that restrict read/write to specific roles. |
| **Secrets** | Never hard‑code secrets. Use `var.<name>` with `sensitive = true` and feed values via: <br>• Environment variables (`TF_VAR_name`) <br>• Encrypted files (`*.tfvars.enc` + `sops`) <br>• Vault/Parameter Store (via data sources) |
| **Plan approvals** | In CI: `terraform plan -out=plan.out` → store artifact → manual approval → `terraform apply plan.out` |
| **Drift detection** | Run `terraform plan` regularly (e.g., nightly) and alert on changes. |
| **Policy as Code** | *Sentinel* (Terraform Cloud) or *OPA* (`conftest`) to enforce rules (e.g., no public S3 buckets). |
| **Testing** | Use `terraform validate`, `tflint`, `checkov`, and optionally `terratest` (Go) or `kitchen-terraform`. |
| **Rollback strategy** | Keep previous state snapshots (S3 versioning) and be ready to `terraform apply` a prior plan. |
| **Logging** | Enable CloudTrail for AWS API calls; Terraform Cloud logs all runs. |
| **Tagging convention** | Centralise tags via a variable or module to ensure cost allocation and governance. |
| **Resource naming** | Use `${terraform.workspace}` or a `var.environment` prefix to avoid collisions. |
| **Concurrency** | Use workspaces or separate state files per environment; never run two `apply`s against the same state concurrently. |
| **CI/CD integration** | Example GitHub Actions snippet: <br>```yaml<br>name: Terraform CI<br>on: [push, pull_request]<br>jobs:<br>  fmt:<br>    runs-on: ubuntu-latest<br>    steps:<br>      - uses: actions/checkout@v4<br>      - uses: hashicorp/setup-terraform@v2<br>        with: { terraform_version: 1.6.6 }<br>      - run: terraform fmt -check -recursive<br>  validate:<br>    needs: fmt<br>    runs-on: ubuntu-latest<br>    steps:<br>      - uses: actions/checkout@v4<br>      - uses: hashicorp/setup-terraform@v2<br>        with: { terraform_version: 1.6.6 }<br>      - run: terraform init -backend=false<br>      - run: terraform validate<br>  plan:<br>    if: github.ref == 'refs/heads/main' && github.event_name == 'pull_request'<br>    needs: validate<br>    runs-on: ubuntu-latest<br>    steps:<br>      - uses: actions/checkout@v4<br>      - uses: hashicorp/setup-terraform@v2<br>        with: { terraform_version: 1.6.6 }<br>      - run: terraform init<br>      - run: terraform plan -out=tfplan<br>      - uses: actions/upload-artifact@v4<br>        with: { name: tfplan, path: tfplan }<br>``` |

---

## 5️⃣ Common Gotchas & How to Avoid Them

| Issue | Why it Happens | Fix / Prevent |
|-------|----------------|---------------|
| **State file gets corrupted** | Manual edits, concurrent runs, network glitches | Use remote backend with locking; never edit `*.tfstate` directly. |
| **Provider API limits** | Large `apply` with many resources | Split into logical modules or use `-target` for phased rollout. |
| **Accidental resource deletion** | `terraform destroy` run on wrong workspace | Always double‑check `terraform workspace show` and use `-var-file` that points to prod. |
| **Sensitive data leaks** | Outputting secrets, committing `.tfvars` | Mark variables `sensitive = true`; avoid `output` of secrets; `.gitignore` all `*.tfvars`. |
| **Version drift** | Team members using different Terraform/provider versions | Enforce version via `required_version` and CI; store `.terraform-version` in repo. |
| **Hard‑coded ARNs/IDs** | Makes code non‑portable | Use data sources or module outputs to discover IDs dynamically. |
| **Missing dependencies** | Resources created out of order causing failures | Use implicit dependencies (`resource` references) or explicit `depends_on`. |
| **Large plan diffs** | Too many changes in one PR, hard to review | Adopt “small‑batch” changes: one feature per PR, use `-target` for incremental rollout. |

---

## 6️⃣ Example Minimal Production Module (VPC)

```hcl
# modules/vpc/main.tf
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = merge(var.tags, {
    Name = "${var.name}-${terraform.workspace}"
  })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name}-public-${count.index}"
  })
}

/* … additional resources (IGW, route tables, etc.) … */
```

```hcl
# modules/vpc/variables.tf
variable "name" {
  description = "Base name for resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}
```

```hcl
# environments/prod/main.tf
module "vpc" {
  source = "../../modules/vpc"

  name               = "myapp"
  cidr_block         = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  tags = {
    Environment = "prod"
    Owner       = "platform-team"
  }
}
```

---

## 7️⃣ One‑Page “Cheat Sheet” (copy‑paste)

```text
# ── Terraform Production Cheat Sheet ──

## Init / Backend
terraform init                     # first run, sets up backend & providers
terraform init -reconfigure        # change backend config

## Workspace (env) handling
terraform workspace new dev
terraform workspace select prod
terraform workspace list

## Planning & Applying
terraform plan -out=tfplan
terraform apply tfplan
terraform apply -auto-approve      # use only in fully‑automated pipelines

## State
terraform state list
terraform state show <addr>
terraform state mv <old> <new>
terraform state pull > state.json   # backup
terraform state push state.json     # restore

## Variables & Secrets
# env var: TF_VAR_name=value
# .tfvars (git‑ignored) or encrypted with sops
variable "db_password" { type = string; sensitive = true }

## Remote Backend (AWS example)
terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "tf-lock"
    encrypt        = true
  }
}

## Provider Pinning
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

## Lint / Validate (CI)
terraform fmt -check
terraform validate
tflint
checkov -d .

## Policy (Sentinel example)
policy "no_public_s3" {
  source = <<EOT
    import "tfplan/v2" as tfplan
    main = rule {
      all tfplan.resource_changes as rc {
        rc.type is "aws_s3_bucket" and
        rc.change.after.acl is not "public-read"
      }
    }
  EOT
}

## Tagging convention
tags = {
  Name        = "${var.project}-${terraform.workspace}"
  Environment = terraform.workspace
  Owner       = var.owner
  CostCenter  = var.cost_center
}

## CI snippet (GitHub Actions)
# see full example in section 4 (CI/CD integration)

# ── End of Cheat Sheet ──
```

---

### 📌 TL;DR Checklist for a Production Run

1. **Pin versions** (`required_version`, provider `version`).  
2. **Configure remote backend** with encryption & DynamoDB lock.  
3. **Store secrets** outside code (`TF_VAR_`, Vault, SSM, sops).  
4. **Run `terraform fmt`, `validate`, `tflint`, `checkov`** in CI.  
5. **Generate & review a plan** (`terraform plan -out=plan.out`).  
6. **Apply only after approval** (manual or gated CI).  
7. **Tag everything** consistently.  
8. **Enable policy checks** (Sentinel/OPA).  
9. **Monitor drift** (nightly plans, CloudTrail).  
10. **Backup state** (S3 versioning, snapshots).  

Follow the sections above, adapt the snippets to your cloud/provider, and you’ll have a solid, production‑ready Terraform workflow. Happy provisioning!

