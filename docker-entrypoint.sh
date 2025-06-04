#!/bin/sh
set -e

# Aguardar o PostgreSQL estar pronto
echo "Aguardando PostgreSQL..."
until pg_isready -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER; do
  echo "PostgreSQL indisponível - aguardando..."
  sleep 2
done
echo "PostgreSQL está pronto!"

# Executar migrações do banco de dados
echo "Executando migrações do banco de dados..."
npx prisma migrate deploy

# Iniciar a aplicação
echo "Iniciando Cal.com..."
exec yarn start 