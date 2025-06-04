# Estágio de build
FROM node:18-alpine AS builder

# Instalar todas as dependências necessárias
RUN apk add --no-cache \
    postgresql-client \
    python3 \
    make \
    g++ \
    curl \
    git \
    openssh-client \
    bash \
    ca-certificates \
    tzdata \
    && curl -o- -L https://yarnpkg.com/install.sh | sh

# Configurar timezone
ENV TZ=America/Sao_Paulo

# Criar diretório da aplicação
WORKDIR /app

# Copiar arquivos de configuração
COPY . .

# Instalar dependências e buildar
RUN yarn install --frozen-lockfile --network-timeout 1000000
RUN yarn build

# Estágio final
FROM node:18-alpine

# Instalar todas as dependências necessárias
RUN apk add --no-cache \
    postgresql-client \
    python3 \
    make \
    g++ \
    curl \
    git \
    openssh-client \
    bash \
    ca-certificates \
    tzdata \
    && curl -o- -L https://yarnpkg.com/install.sh | sh

# Configurar timezone
ENV TZ=America/Sao_Paulo

WORKDIR /app

# Copiar arquivos do estágio de build
COPY --from=builder /app/package.json .
COPY --from=builder /app/yarn.lock .
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules ./node_modules

# Criar diretório para certificados SSL
RUN mkdir -p /letsencrypt

# Expor portas
EXPOSE 3000

# Script de inicialização
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Configurar variáveis de ambiente padrão
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

ENTRYPOINT ["docker-entrypoint.sh"] 