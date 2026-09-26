#!/usr/bin/env bash
# ==============================================================================
# Oryza-Elo: Build & Sync Local Dashboard to Engine
# ==============================================================================
# Compila a aplicação Flutter Web 'apps/local' e copia os assets estáticos
# diretamente para 'oryzaelo_engine/src/presentation/static'.
# ==============================================================================

set -euo pipefail

# Paleta de cores para output amigável
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# 1. Localização dos diretórios dos repositórios
if [ -d "$SCRIPT_DIR/../apps/local" ]; then
    ORYZAELO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [ -d "$SCRIPT_DIR/apps/local" ]; then
    ORYZAELO_DIR="$SCRIPT_DIR"
else
    ORYZAELO_DIR="/home/wilsonborba/Documents/Others/Asodya/oryzaelo"
fi

if [ -d "$ORYZAELO_DIR/../oryzaelo_engine" ]; then
    ENGINE_DIR="$(cd "$ORYZAELO_DIR/../oryzaelo_engine" && pwd)"
else
    ENGINE_DIR="/home/wilsonborba/Documents/Others/Asodya/oryzaelo_engine"
fi

APP_LOCAL_DIR="$ORYZAELO_DIR/apps/local"
BUILD_WEB_DIR="$APP_LOCAL_DIR/build/web"
ENGINE_STATIC_DIR="$ENGINE_DIR/src/presentation/static"

SKIP_BUILD=false

for arg in "$@"; do
    case "$arg" in
        -s|--skip-build)
            SKIP_BUILD=true
            ;;
        -h|--help)
            echo "Uso: ./scripts/copy_local_web_to_engine.sh [opções]"
            echo ""
            echo "Opções:"
            echo "  -s, --skip-build    Pula a compilação do Flutter e apenas copia a build existente"
            echo "  -h, --help          Mostra esta mensagem de ajuda"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida: $arg${NC}"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}🌾  Oryza-Elo • Sincronizador de Frontend Local -> Engine Edge  🌾${NC}"
echo -e "${CYAN}================================================================${NC}"
echo -e "Frontend: ${YELLOW}$APP_LOCAL_DIR${NC}"
echo -e "Engine:   ${YELLOW}$ENGINE_STATIC_DIR${NC}"

# 2. Compilar Flutter Web se necessário
if [ "$SKIP_BUILD" = false ]; then
    echo -e "\n${CYAN}==> [1/3] Compilando Flutter Web em modo release (apps/local)...${NC}"
    cd "$APP_LOCAL_DIR"
    BKK_TIMESTAMP=$(TZ="Asia/Bangkok" date +"%Y-%m-%d %H:%M +07")
    flutter build web --release \
        --dart-define=BUILD_TIMESTAMP="$BKK_TIMESTAMP"
else
    echo -e "\n${YELLOW}==> [1/3] Pulando compilação (--skip-build selecionado)...${NC}"
    if [ ! -f "$BUILD_WEB_DIR/index.html" ]; then
        echo -e "${RED}Erro: Arquivo $BUILD_WEB_DIR/index.html não encontrado. Execute sem --skip-build para compilar.${NC}"
        exit 1
    fi
fi

# 3. Preparar diretório de destino no engine
echo -e "\n${CYAN}==> [2/3] Preparando diretório de destino no engine...${NC}"
mkdir -p "$ENGINE_STATIC_DIR"
# Limpar arquivos antigos para evitar resíduos de compilações anteriores
rm -rf "$ENGINE_STATIC_DIR"/*

# 4. Copiar arquivos compilados
echo -e "\n${CYAN}==> [3/3] Copiando bundle compilado para o engine...${NC}"
cp -r "$BUILD_WEB_DIR"/* "$ENGINE_STATIC_DIR"/

# 5. Validação de integridade do pacote copiado
CRITICAL_FILES=("index.html" "main.dart.js" "flutter.js" "canvaskit" "assets")
MISSING=0
for item in "${CRITICAL_FILES[@]}"; do
    if [ ! -e "$ENGINE_STATIC_DIR/$item" ]; then
        echo -e "${RED}  ❌ Ausente: $item${NC}"
        MISSING=$((MISSING + 1))
    else
        echo -e "${GREEN}  ✓ Verificado: $item${NC}"
    fi
done

if [ "$MISSING" -gt 0 ]; then
    echo -e "\n${RED}Erro: $MISSING item(ns) essencial(is) não encontrado(s) após a cópia.${NC}"
    exit 1
fi

TOTAL_FILES=$(find "$ENGINE_STATIC_DIR" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$ENGINE_STATIC_DIR" | cut -f1)

# 6. Verificar configuração do .env no engine
ENGINE_ENV_FILE="$ENGINE_DIR/.env"
if [ -f "$ENGINE_ENV_FILE" ]; then
    if ! grep -q "^STATIC_DIR=" "$ENGINE_ENV_FILE"; then
        echo -e "\n${YELLOW}Nota: Adicionando STATIC_DIR=src/presentation/static em $ENGINE_ENV_FILE${NC}"
        echo "STATIC_DIR=src/presentation/static" >> "$ENGINE_ENV_FILE"
    else
        sed -i 's|^STATIC_DIR=.*|STATIC_DIR=src/presentation/static|' "$ENGINE_ENV_FILE"
    fi
fi

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}✓ Sincronização concluída com sucesso!${NC}"
echo -e "  Arquivos copiados: ${YELLOW}$TOTAL_FILES${NC}"
echo -e "  Tamanho total:     ${YELLOW}$TOTAL_SIZE${NC}"
echo -e "  Destino estático:  ${YELLOW}$ENGINE_STATIC_DIR${NC}"
echo -e "${GREEN}================================================================${NC}"
echo -e "Agora você pode iniciar o engine na porta 8005 para servir a aplicação offline."
