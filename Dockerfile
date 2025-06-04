# Usar a imagem oficial do Cal.com como base
FROM calcom/cal.com:latest

# Instalar dependências adicionais
RUN apk add --no-cache \
    postgresql-client \
    curl \
    bash \
    tzdata

# Configurar timezone
ENV TZ=America/Sao_Paulo

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