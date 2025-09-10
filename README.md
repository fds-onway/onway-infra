# Terraform Project Setup

Este repositório contém a infraestrutura do projeto gerenciada via Terraform.

Siga os passos abaixo para inicializar o projeto corretamente.

---

## 1. Baixar os arquivos sensíveis

O arquivo `.zip` contendo os arquivos sensíveis (`backend.s3.tfvars`, `sensitive.auto.tfvars`, etc.) está disponível no canal do Discord nomeado **"arquivos"**.

Baixe o arquivo `.zip` para sua máquina.

---

## 2. Descompactar os arquivos

Extraia o conteúdo do `.zip` dentro da pasta `src` do repositório.

```bash
unzip arquivos.zip -d src
```

Após isso, a estrutura de pastas deve ficar semelhante a:

```
src/
├── backend.s3.tfvars
├── sensitive.auto.tfvars
└── ...
```

## 3. Inicializar o Terraform

Dentro da pasta src, inicialize o Terraform usando o backend configurado:

```bash
cd src
terraform init -backend-config=backend.s3.tfvars
```

Isso garante que o Terraform irá armazenar o state remoto corretamente no S3 e ler as configurações sensíveis.

## 4. Usar o Terraform

Após a inicialização, você pode utilizar o Terraform normalmente:

```bash
terraform plan
terraform apply
terraform destroy
```

Lembre-se de não versionar os arquivos .tfvars sensíveis no Git para manter as credenciais seguras.
