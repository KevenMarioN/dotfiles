#!/usr/bin/env bash

set -e

echo "🔍 Localizando diretório de binários do Go via asdf..."

GOBIN="$(asdf where golang)/bin"
MASON_BIN="$HOME/.local/share/nvim/mason/bin"

if [ ! -d "$GOBIN" ]; then
  echo "❌ Diretório de binários do Go não encontrado: $GOBIN"
  exit 1
fi

echo "📁 Criando diretório de destino do Mason (se necessário): $MASON_BIN"
mkdir -p "$MASON_BIN"

echo "🔗 Criando symlinks de $GOBIN → $MASON_BIN"

for bin in "$GOBIN"/*; do
  if [ -f "$bin" ] && [ -x "$bin" ]; then
    ln -sf "$bin" "$MASON_BIN/$(basename "$bin")"
    echo "✅ Linkado: $(basename "$bin")"
  fi
done

echo "🎉 Todos os binários do Go foram linkados para o Mason."
