# Cal.com com Docker Compose

Este projeto configura uma instância do Cal.com com Traefik como proxy reverso e PostgreSQL como banco de dados.

## Requisitos

- Docker
- Docker Compose
- Git
- Domínio configurado com DNS apontando para o servidor

## Instalação

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITÓRIO]
cd [NOME_DO_DIRETÓRIO]
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
# Edite o arquivo .env com suas configurações
```

3. Crie o diretório para os certificados SSL:
```bash
mkdir -p letsencrypt
```

4. Inicie os serviços:
```bash
docker compose up -d
```

## Configuração do Google Calendar/Meet

1. Acesse o [Google Cloud Console](https://console.cloud.google.com)
2. Crie um novo projeto
3. Ative as APIs do Google Calendar e Google Meet
4. Configure as credenciais OAuth2:
   - Tipo: Aplicativo Web
   - URIs de redirecionamento autorizados: `https://[SEU_DOMINIO]/api/integrations/googlecalendar/callback`
5. Copie o Client ID e Client Secret para o arquivo `.env`

## Estrutura do Projeto

```
.
├── docker-compose.yml    # Configuração dos serviços Docker
├── .env                 # Variáveis de ambiente
├── .env.example         # Exemplo de variáveis de ambiente
├── letsencrypt/        # Diretório para certificados SSL
└── README.md           # Este arquivo
```

## Serviços

- **Traefik**: Proxy reverso com SSL automático
- **PostgreSQL**: Banco de dados
- **Cal.com**: Aplicação principal

## Portas

- 80: HTTP (redireciona para HTTPS)
- 443: HTTPS
- 3000: Cal.com (interno)

## Backup

O banco de dados PostgreSQL é persistido em um volume Docker. Para fazer backup:

```bash
docker compose exec postgres pg_dump -U postgres calcom > backup.sql
```

## Restauração

```bash
cat backup.sql | docker compose exec -T postgres psql -U postgres calcom
```

## Atualização

Para atualizar os serviços:

```bash
docker compose pull
docker compose up -d
```

## Troubleshooting

1. Verifique os logs:
```bash
docker compose logs -f
```

2. Verifique o status dos containers:
```bash
docker compose ps
```

3. Reinicie um serviço específico:
```bash
docker compose restart [NOME_DO_SERVIÇO]
``` 