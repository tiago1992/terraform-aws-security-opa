📝 Título do artigo:

“Segurança como Código: Validando políticas na AWS com OPA/Rego e Terraform antes do deploy”
🎯 Objetivo:

Mostrar como usar OPA (Open Policy Agent) com Rego para aplicar políticas de segurança no pipeline de Terraform, garantindo que nenhuma infraestrutura insegura vá pra AWS.
🔐 Cenário do case:

Você está criando um ambiente seguro na AWS com Terraform (VPC, EC2, IAM, S3, etc). Mas, antes de aplicar, precisa garantir:

    Nenhum bucket S3 seja público

    Nenhuma instância EC2 tenha IP público

    Políticas IAM não contenham "Action": "*"

    CloudTrail esteja habilitado

    SGs não exponham portas sensíveis (ex: 0.0.0.0/0 na 22 ou 3389)

🧰 Ferramentas usadas:

    Terraform

    OPA (Open Policy Agent)

    Rego (linguagem para escrever as regras)

    terraform plan + conftest para validar antes do apply

📁 Exemplo prático:
✅ Estrutura:

.
├── main.tf
├── policy/
│   ├── s3-no-public.rego
│   ├── ec2-no-public-ip.rego
│   └── iam-no-wildcard.rego

🔧 Exemplo de regra Rego:
📄 s3-no-public.rego

package terraform.aws.s3

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  not resource.change.after.block_public_acls
  msg := "S3 bucket com ACL pública detectado"
}

📄 ec2-no-public-ip.rego

package terraform.aws.ec2

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"
  resource.change.after.associate_public_ip_address
  msg := "Instância EC2 com IP público detectada"
}

▶️ Rodando a validação:

    Gera o plano Terraform em JSON:

terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json

    Roda o OPA via Conftest:

conftest test tfplan.json --policy ./policy

✅ Resultado esperado:

    Se tudo estiver conforme as regras → deploy permitido

    Se houver violação (ex: bucket público ou EC2 com IP público) → bloqueia o apply com mensagem clara

🧠 Conclusão:

Com OPA + Rego, você adiciona uma camada poderosa de governança automatizada no ciclo de infraestrutura. É como um “lint de segurança” antes do terraform apply.
💥 Extras que você pode incluir no artigo:

    Como integrar no CI/CD (ex: GitLab CI ou GitHub Actions)

    Como versionar políticas Rego

    Como escalar isso para times com múltiplos ambientes (dev/stage/prod)