# Configuração de Infraestrutura do OnWay

Este é o repositório "inicial" de toda sua configuração de infraestrutura para hospedar o serviço, ele faz todas as configurações necessárias para o website e a API funcionarem corretamente.

---

## Tabela de Conteúdos

- [Como aplicar a configuração](#como-aplicar-a-configuração)
- [Configurações nos repositórios](#configurações-nos-repositórios)
- [Recursos que são criados](#recursos-que-são-criados)

---

## Como Aplicar a configuração

### Terraform:
Esta é a primeira configuração que precisa ser aplicada, pois é ela que irá criar a "fundação" do serviço.

#### 1. Recursos iniciais
Estas são as configurações que você precisa "manualmente" para aplicar a infraestrutura, inicialmente você precisa de:
- Uma conta na CloudFlare
- Uma conta na DigitalOcean
- Uma conta na **AWS**, com uma **chave de acesso** configurada corretamente em sua máquina
- Um domínio registrado na CloudFlare

Ao ter essas 3 coisas "principais", você pode partir para as informações que serão configuradas no Terraform:
- Uma **chave de API da sua conta CloudFlare**, que tenha **permissões** necessárias para **manipular registros DNS**.
- **O ID da sua zona CloudFlare**, o qual pode ser pego facilmente ao entrar no CloudFlare -> `<Selecionar seu domínio>` -> Scrollar até o final -> Pegar o valor do campo "Zone ID" dentro da seção "API"
- Uma **chave de API da DigitalOcean** com permissão geral à sua conta

#### 2. Arquivo `sensitive.auto.tfvars`
Este é o primeiro arquivo que você precisa configurar dentro do repositório, ele irá conter as informações sensíveis que pegamos anteriorment, então, não adicione ele ao git.

Ele terá a seguinte estrutura:
```HCL
cloudflare_api_token = <SUA_CHAVE_DE_API_CLOUDFLARE>
cloudflare_zone_id   = <ZONE_ID_DO_SEU_DOMINIO_CLOUDFLARE>
digitalocean_token   = <SEU_TOKEN_DIGITALOCEAN>
domain               = <SEU_DOMÍNIO(ex: crassus.app.br)>
```

#### 3. Configuração de Backend
Uma vez configurado isso, você precisará entrar dentro do arquivo `_backend.tf` e inserir suas configurações de Backend, atualmente está configurado em um Bucket S3, e se você quiser seguir dessa maneira, só alterar o campo de "bucket" para o nome do seu bucket que você está utilizado. (Também não se esqueça de configurar o CLI da AWS em seu dispositivo)

#### 4. Aplicando a infraestrutura
Uma vez configurado tudo isso, você pode executar os comandos básicos do terraform:
```bash
terraform init
terraform plan
terraform apply
```

Ao dar Apply, atente-se ao arquivo `server_key.pem` que será criado dentro da pasta `src/ansible`, ele será a chave SSH que será utilizada em seu servidor, mantenha-a fora do git também.
Com isso, toda sua infraestrutura estará pronta para uso.

#### 5. Informações para salvar
Com toda a infraestrutura criada, algumas informações importantes serão criadas, é interessante que você salve-as, pois elas serão utilizadas com bastante frequência, a listinha delas é:

- **IP Público do Servidor:**
```bash
terraform output -raw onway_droplet_ip_address
```

- **Chave SSH do Servidor:**
É o conteúdo do arquivo `src/ansible/server_key.pem`

- **ID da Distribuição CloudFront**
```bash
terraform output -raw website_cloudfront_id
```

- **Chave de Acesso AWS para o usuário CloudFront**
```bash
terraform output -raw cloudfront_manager_access_key_id
terraform output -raw cloudfront_manager_secret_access_key
```

### Ansible:
Uma vez que sua infraestrutura Terraform estiver criada e funcionando, cabe ao Ansible configurá-la e deixá-la pronta para o deploy e hospedagem das aplicações.

#### 1. Configurando o `inventory.yml`
Este é o primeiro passo antes de rodar o ansible para configurar seu servidor
Basta editar o arquivo `src/ansible/inventory.yml` e colocar as suas informações, principalmente:
- `project_domain`: Será o **domínio que será utilizado para sua API**
- `certbot_email`: O E-mail que será notificado quando o certificado da API estiver prestes à vencer, provavelmente nunca será utilizado visto que o certificado se renovará automaticamente.

#### 2. Modificando permissões da chave SSH
O terraform ao criar o arquivo da chave, não consegue configurar questões de permissão, então você terá que fazer manuealmente com o comando:
```bash
chmod 400 ./server_key.pem
```

#### 3. Aplicando as configurações
Agora que está tudo preparado, você pode pegar [o IP público do servidor](#5-informações-para-salvar) e executar o comando:
```bash
ansible-playbook -i inventory.yml setup-server.yml -e "ansible_host=<IP_PÚBLICO_DO_SERVIDOR>"
```
Com isso, seu servidor ficará pronto para hospedar a API.

---

## Configurações nos repositórios

Agora que você possui toda a sua infraestrutura configurada, você precisa configurar elas nos repositórios para que todos os workflows de deploy funcionem corretamente.

### Configuração no Docker Hub

Mais uma configuração manual que deve ser feita, mas essa é bem simples.
Basicamente, **crie uma conta no Docker Hub**, e crie um repositório(privado ou público, tanto faz) dentro dele.
E então, salve essas 3 informações:
- Username
- Senha
- Nome do Repositório

Pois você irá utilizá-las para configurar o **.env** do repositório da API posteriormente

### Configuração de Discord

Essa é a última parte "manual" que deve ser criada.
Em seu servidor de discord, crie um **Webhook** com acesso a um canal específico, este será o canal onde você será notificado de todos os workflows feitos, se deram certo ou não, e coisa do tipo.
Ao criar este webhook, **copie o link dele** e deixe salvo.

### [OnWay-Website](https://github.com/fds-onway/onway-website)

Este é o repositório do website que é o "CMS" do projeto, para ele não terá configurações de SSH e coisa do tipo, apenas configurações de **Cloudfront, AWS e Discord**

Dentro do repositório em **Settings** -> **Secrets and Variables** -> **Actions**, adicione os seguintes secrets (com o exato mesmo nome):
- **AWS_ACCESS_KEY_ID**: Obtido na seção [informações para salvar](#5-informações-para-salvar)
- **AWS_SECRET_ACCESS_KEY**: Obtido na seção [informações para salvar](#5-informações-para-salvar)
- **CLOUDFRONT_DISTRIBUTION_ID**: Obtido na seção [informações para salvar](#5-informações-para-salvar)
- **DEPLOY_CHANNEL_DISCORD_WEBHOOK**: Aquele que você copiou [anteriormente](#configuração-de-discord)

### [OnWay-Backend](https://github.com/fds-onway/onway-backend)

Este é o repositório da API, e por mexer com coisas envolvendo servidor, Docker, e coisa do tipo, requer mais secrets que o anterior
Novamente, dentro do repositório, vá em **Settings** -> **Secrets and Variables** -> **Actions**, adicione os seguintes secrets (com o exato mesmo nome):
- **DOCKER_USERNAME**: Seu username do Docker, configurado [neste passo](#configuração-no-docker-hub)
- **DOCKER_PASSWORD**: A senha do seu usuário Docker, também configurado [neste passo](#configuração-no-docker-hub)
- **SERVER_PUBLIC_IP**: Obtido na seção [informações para salvar](#5-informações-para-salvar)
- **SERVER_SSH_KEY**: Obtido na seção [informações para salvar](#5-informações-para-salvar)
- **DOTENV_CONTENT**: O conteúdo do arquivo `.env` que você populou baseado no `.env.example` do repositório, para mais informações, só ler o README do repositório de backend.
- **DEPLOY_CHANNEL_DISCORD_WEBHOOK**: Aquele mesmo que você copiou [anteriormente](#configuração-de-discord)

---

## Recursos que são criados

Ao aplicar a configuração do Terraform, os seguintes recursos serão provisionados na sua infraestrutura:

- **DigitalOcean**:
  - 1 Droplet do nível mais baixo, com Debian 12
  - Chave SSH de acesso ao Droplet
Esta é a única parte que possui custo, com ele sendo apenas $4 por mês.

- **AWS**:
  - 1 Certificado ACM Wildcard para o domínio configurado no [sensitive.auto.tfvars](#2-arquivo-sensitiveautotfvars)
  - 1 Bucket S3 que irá conter os arquivos do website, com suas configurações de:
    - Acesso público para leitura
    - Controle de ownership apenas para o dono do bucket
    - Configuração de CORS para acesso de outros navegadores para o website
    - Policy de acesso público
  - 1 Distribuição CloudFront "conectada" ao Bucket, para fazer a distribuição do website, também utilizando o certificado ACM
  - 1 Usuário IAM com acesso total ao bucket e ao cloudfront, para fazer deploy do website e configurar invalidações (para limpar o cache)
  - Chave de acesso para este mesmo usuário

- **CloudFlare**:
  - 1 Registro **CNAME** para validação do **Certificado ACM** criado na AWS
  - 1 Registro **CNAME** que aponta para o endpoint da distribuição cloudfront criada na AWS
  - 1 Registro **A** que aponta para o IP da instância que ficará a API
