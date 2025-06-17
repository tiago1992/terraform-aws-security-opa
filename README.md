# Terraform + OPA (Rego): Segurança na AWS

Este projeto demonstra como validar políticas de segurança na AWS antes do deploy usando Terraform + OPA.

## 🚀 O que você encontra aqui

- Provisão de recursos na AWS (S3, EC2)
- Políticas Rego para bloquear:
  - Buckets S3 públicos
  - EC2 com IP público

## 🛠 Como rodar

```bash
terraform init
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
conftest test tfplan.json --policy policy/
