## Quick‑Start Ways to Keep Secrets Out of Your Terraform Code and State

| What it does | How to use it | Why it helps |
|--------------|---------------|--------------|
| **Mark variables as `sensitive`** | ```hcl\nvariable \"db_password\" {\n  description = \"Database master password\"\n  type        = string\n  sensitive   = true   # hides value in plan/apply output\n}\n``` | Terraform redacts the value in `terraform plan`, `terraform apply`, logs and the CLI output. The value is still stored in the state file, so you still need a secure backend. |
| **Pull secrets from environment variables** | ```bash\nexport TF_VAR_db_password=\"SuperSecret123\"\nterraform apply\n``` | The secret never appears in `.tf` files or version‑control. Terraform reads any variable whose name is prefixed with `TF_VAR_`. |
| **Use a remote, encrypted backend for state** | ```hcl\nterraform {\n  backend \"s3\" {\n    bucket         = \"my‑tf‑state\"\n    key            = \"prod/terraform.tfstate\"\n    region         = \"us‑west‑2\"\n    encrypt        = true            # SSE‑S3 or SSE‑KMS\n    dynamodb_table = \"tf‑lock\"\n  }\n}\n``` | State (which contains the actual secret values) is stored encrypted at rest and in transit. The backend also provides locking to avoid concurrent writes. |
| **Store secrets in a dedicated secret manager** (Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager, etc.) | Example with AWS Secrets Manager: <br>```hcl\ndata \"aws_secretsmanager_secret_version\" \"db_pwd\" {\n  secret_id = \"arn:aws:secretsmanager:us-west-2:123456789012:secret:mydbpwd\"\n}\n\nresource \"aws_db_instance\" \"example\" {\n  # …\n  password = data.aws_secretsmanager_secret_version.db_pwd.secret_string\n}\n``` | Secrets live outside Terraform entirely. Terraform only reads them at runtime, so they never get written to the state file (unless you explicitly output them). Most managers also give you rotation, audit logs and fine‑grained IAM policies. |
| **Encrypt files that *must* contain secrets** (e.g., `.tfvars` files) | Use tools like **SOPS**, **git‑crypt**, or **GPG**: <br>```bash\nsops -e secrets.auto.tfvars > secrets.auto.tfvars.enc\n# Decrypt on the fly when running Terraform\nexport SOPS_AGE_KEY_FILE=~/.config/sops/age.key\nsops -d secrets.auto.tfvars.enc | terraform apply -var-file=-\n``` | The encrypted file can be committed safely; only people with the decryption key can read the values. |
| **Never commit state or `.tfvars` files** | Add to `.gitignore`: <br>```gitignore\n*.tfstate*\n*.tfplan\n*.auto.tfvars\n``` | Prevents accidental leakage through source control. |
| **Use short‑lived credentials** (AWS STS, Azure AD tokens, GCP short‑lived service accounts) | Instead of hard‑coding long‑term keys, configure the provider to assume a role that issues temporary credentials. | Even if a credential is exposed, it expires quickly, limiting the window of abuse. |
| **Leverage Terraform Cloud/Enterprise workspaces** | Store variables as **Sensitive** in the workspace UI, enable **Remote Operations** so runs happen on the service, not locally. | Secrets never touch your local machine; they are stored encrypted by Terraform Cloud and are masked in UI logs. |

---

### Putting It All Together – A Minimal, Secure Workflow

1. **Create a remote backend** (S3 + DynamoDB, Terraform Cloud, etc.) with encryption enabled.  
2. **Store all secrets in a secret manager** (e.g., AWS Secrets Manager).  
3. **Reference those secrets via data sources** in your `.tf` files.  
4. **Mark any variable that might still hold a secret as `sensitive = true`.**  
5. **Export any required provider credentials via environment variables** (`TF_VAR_…` or provider‑specific vars).  
6. **Add state files, `.tfvars`, and any plaintext secret files to `.gitignore`.**  
7. **(Optional) Encrypt any `.tfvars` you must keep in the repo** with SOPS/GPG.  

Result:  

- Secrets never live in version‑controlled code.  
- They are not printed in Terraform CLI output.  
- They are stored encrypted at rest (state backend) and in transit.  
- Access is controlled by the IAM policies of the secret manager and the backend.

---

### TL;DR Checklist

- ✅ `sensitive = true` on secret variables.  
- ✅ Use **environment variables** (`TF_VAR_…`) for simple secrets.  
- ✅ Store real secrets in **Vault / AWS Secrets Manager / Azure Key Vault / GCP Secret Manager** and read them with data sources.  
- ✅ Keep **state** in an **encrypted remote backend**.  
- ✅ **Never commit** state files or plain `.tfvars`. Add them to `.gitignore`.  
- ✅ If you must keep a `.tfvars` file, **encrypt it** with SOPS/GPG.  
- ✅ Prefer **short‑lived credentials** and **role‑based IAM** policies.  

Following these steps gives you the easiest, “good‑enough” protection for most teams while keeping the workflow simple. If you need tighter compliance (audit logs, automatic rotation, dynamic secrets), integrate a dedicated secret manager like HashiCorp Vault and enable its dynamic‑secret features.

