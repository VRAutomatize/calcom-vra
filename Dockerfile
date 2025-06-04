# Estágio de build
FROM node:18-alpine AS builder

# Instalar dependências necessárias
RUN apk add --no-cache \
    postgresql-client \
    python3 \
    make \
    g++ \
    curl

# Instalar Yarn de forma mais robusta
RUN curl -o- -L https://yarnpkg.com/install.sh | sh

# Criar diretório da aplicação
WORKDIR /app

# Copiar arquivos de configuração
COPY . .

# Instalar dependências e buildar
RUN yarn install --frozen-lockfile
RUN yarn build

# Estágio final
FROM node:18-alpine

# Instalar dependências necessárias
RUN apk add --no-cache \
    postgresql-client \
    python3 \
    make \
    g++ \
    curl

# Instalar Yarn de forma mais robusta
RUN curl -o- -L https://yarnpkg.com/install.sh | sh

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

ENTRYPOINT ["docker-entrypoint.sh"] 