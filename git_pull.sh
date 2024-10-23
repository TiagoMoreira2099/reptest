#!/bin/bash

# Usa o diretório atual como o diretório do repositório
REPO_DIR=$(pwd)

# Verifica se o diretório existe e navega para o diretório do repositório
if [ ! -d "$REPO_DIR" ]; then
    echo "Erro: Diretório $REPO_DIR não encontrado."
    exit 1
fi

cd "$REPO_DIR" || { echo "Erro: Não foi possível navegar para o diretório $REPO_DIR."; exit 1; }

# Tenta buscar todas as atualizações do repositório remoto
if ! git fetch --all; then
    echo "Erro: Não foi possível buscar atualizações remotas. Verifica a conexão ou o acesso ao repositório."
    exit 1
fi

# Loop por todos os branches locais e faz git pull
for branch in $(git branch | sed 's/*//'); do
    branch=$(echo "$branch" | xargs)  # Remove espaços em branco
    echo "Trocando para o branch: $branch"

    # Tenta fazer checkout do branch
    if ! git checkout "$branch"; then
        echo "Erro: Não foi possível trocar para o branch $branch. Pulando para o próximo."
        continue
    fi

    # Tenta fazer pull do branch atual
    if ! git pull; then
        echo "Erro: Não foi possível atualizar o branch $branch. Pulando para o próximo."
        continue
    fi
done

echo "Todos os branches disponíveis foram atualizados com sucesso."
