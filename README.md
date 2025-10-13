# Configuração de Infraestrutura do OnWay

Este é o repositório "inicial" de toda sua configuração de infraestrutura para hospedar o serviço, ele faz todas as configurações necessárias para o website e a API funcionarem corretamente.

## Tabela de Conteúdos

- [Como aplicar a configuração](#como-aplicar-a-configuração)
- Configurações nos repositórios
- Recursos que são criados
- Explicação dos workflows

## Como Aplicar a configuração

### Terraform:
Esta é a primeira configuração que precisa ser aplicada, pois é ela que irá criar a "fundação" do serviço.

#### 1. Recursos iniciais
Estas são as configurações que você precisa "manualmente" para aplicar a infraestrutura, inicialmente você precisa de:
- Uma conta na CloudFlare
- Uma conta na DigitalOcean
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
