#!/bin/sh
set -e

# Aguardar o PostgreSQL estar pronto
echo "Aguardando PostgreSQL..."
until pg_isready -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER; do
  echo "PostgreSQL indisponível - aguardando..."
  sleep 2
done
echo "PostgreSQL está pronto!"

# Iniciar a aplicação
echo "Iniciando Cal.com..."
exec yarn start 