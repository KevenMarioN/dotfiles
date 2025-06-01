#!/usr/bin/env bash

set -e

PLUGINS_DIR="$HOME/dotfiles/tmux/.tmux/plugins"
REPO_ROOT="$HOME/dotfiles"

cd "$REPO_ROOT"

echo "🔍 Buscando plugins em: $PLUGINS_DIR"

for plugin_path in "$PLUGINS_DIR"/*; do
  [ -d "$plugin_path" ] || continue

  plugin_name=$(basename "$plugin_path")

  # Verifica se já é um submodule
  if git config --file .gitmodules --get-regexp path | grep -q "$plugin_name"; then
    echo "✅ '$plugin_name' já é um submódulo. Pulando..."
    continue
  fi

  # Verifica se é um repositório git válido
  if [ ! -d "$plugin_path/.git" ]; then
    echo "⚠️  '$plugin_name' não é um repositório git. Ignorando..."
    continue
  fi

  # Pega a URL remota do plugin
  url=$(git -C "$plugin_path" remote get-url origin 2>/dev/null)

  if [ -z "$url" ]; then
    echo "❌ Não foi possível obter a URL do plugin '$plugin_name'."
    continue
  fi

  # Adiciona como submodule
  echo "➕ Adicionando '$plugin_name' como submódulo..."
  git submodule add "$url" ".tmux/plugins/$plugin_name"
done

echo "📦 Atualizando submodules..."
git submodule init
git submodule update --remote --merge

echo "✅ Todos os plugins foram adicionados como submódulos com sucesso."
