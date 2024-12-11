#!/usr/bin/env bash

# Obtener el directorio actual
CURRENT_DIR=$(pwd)

# Definir el directorio de caché relativo al directorio actual
CACHE_DIR="$CURRENT_DIR/llama_cache"

# Crear el directorio de caché si no existe
mkdir -p "$CACHE_DIR"

# Construir la imagen Docker
sudo docker build -t llama-33-70b-intruct:latest .

# Ejecutar el contenedor Docker con el volumen montado
sudo docker run -it --rm -p 8004:8004 \
  -v "$CACHE_DIR":/root/.cache/huggingface/hub \
  --env-file .env \
  llama-33-70b-intruct:latest
