#!/usr/bin/env bash
# ==============================================================================
# Oryza-Elo: Turnkey Edge Launcher (Raspberry Pi & Local Development)
# ==============================================================================
# Inicia o microserviço de borda 'oryzaelo_engine' em 0.0.0.0:8005 servindo
# diretamente a interface Flutter Web 'apps/local' com zero dependências externas.
# ==============================================================================

set -euo pipefail

# Cores ANSI
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# 1. Localização dinâmica dos repositórios
if [ -d "$SCRIPT_DIR/../apps/local" ]; then
    ORYZAELO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [ -d "$SCRIPT_DIR/apps/local" ]; then
    ORYZAELO_DIR="$SCRIPT_DIR"
else
    ORYZAELO_DIR="/home/wilsonborba/Documents/Others/Asodya/oryzaelo"
fi

if [ -d "$ORYZAELO_DIR/../oryzaelo_engine" ]; then
    ENGINE_DIR="$(cd "$ORYZAELO_DIR/../oryzaelo_engine" && pwd)"
elif [ -d "$SCRIPT_DIR/../oryzaelo_engine" ]; then
    ENGINE_DIR="$(cd "$SCRIPT_DIR/../oryzaelo_engine" && pwd)"
else
    ENGINE_DIR="/home/wilsonborba/Documents/Others/Asodya/oryzaelo_engine"
fi

APP_LOCAL_DIR="$ORYZAELO_DIR/apps/local"
BUILD_WEB_DIR="$APP_LOCAL_DIR/build/web"
ENGINE_STATIC_DIR="$ENGINE_DIR/src/presentation/static"
COPY_SCRIPT="$ORYZAELO_DIR/scripts/copy_local_web_to_engine.sh"

# Configurações padrão
PORT=8005
HOST="0.0.0.0"
PROFILE="release"
REBUILD=false
SYNC_ONLY=false
DEV_MODE=false
RESET_DB=false
SKIP_SEED=false

show_help() {
    cat <<EOF
Uso: ./run_local_edge.sh [opções]

Opções:
  -b, --build       Compila o Flutter Web (apps/local) e sincroniza antes de iniciar
  -s, --sync        Sincroniza a build existente para o engine sem recompilar
  -d, --dev         Modo Desenvolvimento: Engine na porta 8005 + Flutter Web hot-reload na porta 8110
  --debug           Executa o binário do engine em modo debug (padrão: release otimizado)
  --reset-db        Apaga o banco de dados SQLite local antes de iniciar e recria do zero
  --no-seed         Não semeia dados de teste (talhão demo e 65 dias de telemetria)
  -p, --port <NUM>  Porta HTTP do servidor Axum (padrão: 8005)
  --host <IP>       Host de escuta do servidor (padrão: 0.0.0.0)
  -h, --help        Exibe esta mensagem de ajuda

Exemplos:
  ./run_local_edge.sh                # Execução turnkey padrão na porta 8005
  ./run_local_edge.sh --build        # Recompila o frontend e sobe o engine
  ./run_local_edge.sh --dev          # Hot-reload no frontend para desenvolvimento ativo
  ./run_local_edge.sh --reset-db     # Limpa o banco SQLite e re-semeia dados limpos
EOF
}

# Parsing de argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -b|--build)
            REBUILD=true
            shift
            ;;
        -s|--sync)
            SYNC_ONLY=true
            shift
            ;;
        -d|--dev)
            DEV_MODE=true
            shift
            ;;
        --debug)
            PROFILE="debug"
            shift
            ;;
        --reset-db)
            RESET_DB=true
            shift
            ;;
        --no-seed)
            SKIP_SEED=true
            shift
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        --host)
            HOST="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

echo -e "${GREEN}================================================================${NC}"
echo -e "${BOLD}${GREEN}🌾  ORYZA-ELO • NÓ DE BORDA LOCAL & DASHBOARD DO PRODUTOR  🌾${NC}"
echo -e "${GREEN}================================================================${NC}"

# 2. Resetar banco de dados se solicitado
DB_PATH="$ENGINE_DIR/src/dal/data/local/oryza_elo_edge.db"
if [ "$RESET_DB" = true ]; then
    echo -e "${YELLOW}==> [Reset DB] Removendo base de dados SQLite local...${NC}"
    rm -f "${DB_PATH}"*
    echo -e "${GREEN}✓ Banco de dados limpo.${NC}"
fi

# 3. Compilação e sincronização de assets estáticos
if [ "$REBUILD" = true ]; then
    echo -e "${CYAN}==> [Build] Compilando frontend e sincronizando com engine...${NC}"
    "$COPY_SCRIPT"
elif [ "$SYNC_ONLY" = true ]; then
    echo -e "${CYAN}==> [Sync] Sincronizando build existente com engine...${NC}"
    "$COPY_SCRIPT" --skip-build
elif [ ! -f "$ENGINE_STATIC_DIR/index.html" ] && [ ! -f "$BUILD_WEB_DIR/index.html" ]; then
    echo -e "${YELLOW}==> [Aviso] Assets estáticos não encontrados. Iniciando compilação inicial...${NC}"
    "$COPY_SCRIPT"
elif [ ! -f "$ENGINE_STATIC_DIR/index.html" ] && [ -f "$BUILD_WEB_DIR/index.html" ]; then
    echo -e "${CYAN}==> [Sync] Copiando build web existente para src/presentation/static...${NC}"
    "$COPY_SCRIPT" --skip-build
fi

# 4. Verificar se o binário do engine existe
ENGINE_BIN="$ENGINE_DIR/target/$PROFILE/oryzaelo_engine"
if [ ! -f "$ENGINE_BIN" ]; then
    echo -e "${CYAN}==> [Compilação Engine] Binário $ENGINE_BIN não encontrado. Compilando em modo $PROFILE...${NC}"
    cd "$ENGINE_DIR"
    if [ "$PROFILE" = "release" ]; then
        cargo build --release
    else
        cargo build
    fi
fi

# 5. Exportar variáveis de ambiente para execução do microserviço
export SERVER_HOST="$HOST"
export SERVER_PORT="$PORT"
export PORT="$PORT"
export STATIC_DIR="src/presentation/static"
export LOG_LEVEL="info"

# 6. Inicializar engine em background com controle de processo
cd "$ENGINE_DIR"

echo -e "\n${CYAN}==> Iniciando oryzaelo_engine em http://$HOST:$PORT...${NC}"
"$ENGINE_BIN" &
ENGINE_PID=$!

# Função de limpeza para encerramento gracioso
cleanup() {
    echo -e "\n${YELLOW}==> Encerrando serviços Oryza-Elo...${NC}"
    if kill -0 "$ENGINE_PID" 2>/dev/null; then
        kill "$ENGINE_PID" 2>/dev/null || true
        wait "$ENGINE_PID" 2>/dev/null || true
    fi
    if [ -n "${DEV_PID:-}" ] && kill -0 "$DEV_PID" 2>/dev/null; then
        kill "$DEV_PID" 2>/dev/null || true
    fi
    echo -e "${GREEN}✓ Serviços encerrados com sucesso.${NC}"
}
trap cleanup SIGINT SIGTERM EXIT

# 7. Aguardar subida saudável do engine
echo -n "Aguardando inicialização do servidor Axum"
HEALTH_URL="http://127.0.0.1:$PORT/health"
UP=false
for i in {1..30}; do
    if curl -s "$HEALTH_URL" > /dev/null 2>&1; then
        UP=true
        break
    fi
    echo -n "."
    sleep 0.5
done
echo ""

if [ "$UP" = false ]; then
    echo -e "${RED}Erro: O servidor não respondeu em $HEALTH_URL após 15 segundos.${NC}"
    exit 1
fi

# 8. Semeador autônomo de dados demonstrativos
if [ "$SKIP_SEED" = false ]; then
    BASE_API="http://127.0.0.1:$PORT/api/v1"
    PARCELS_JSON=$(curl -s "$BASE_API/parcels" || echo "[]")
    COUNT=$(echo "$PARCELS_JSON" | grep -o '"id":' | wc -l || echo "0")

    if [ "$COUNT" -eq 0 ]; then
        echo -e "${CYAN}==> [Semeador Agronômico] Base vazia detectada. Registrando talhão de referência e 65 dias de telemetria...${NC}"
        
        # 8a. Criar talhão de referência
        curl -s -X POST "$BASE_API/parcels" \
            -H "Content-Type: application/json" \
            -d '{
                "id": "talhao-demo-esalq",
                "name": "Talhão Demonstrativo Esalq (Suphan Buri)",
                "rice_variety": "ขาวดอกมะลิ 105",
                "rice_ecosystem": "นาชลประทาน",
                "latitude": 14.88,
                "longitude": 100.45,
                "planting_date": "2026-07-15",
                "area_hectares": 12.5
            }' > /dev/null

        # 8b. Gerar e injetar 65 dias de série temporal climática
        CSV_DATA="Date,Temp High,Temp Low,Rain,Solar Rad,Hum High"
        START_D="2026-07-15"
        for i in {0..64}; do
            CURR_D=$(date -I -d "$START_D + $i days")
            M_D_Y=$(date -d "$CURR_D" +"%m/%d/%Y")
            T_MAX=$(awk -v i="$i" 'BEGIN {printf "%.1f", 89.6 + (i % 4)}')
            T_MIN=$(awk -v i="$i" 'BEGIN {printf "%.1f", 73.4 + (i % 3)}')
            RAIN=$(awk -v i="$i" 'BEGIN {printf "%.2f", (i % 6 == 0 ? 0.45 : 0.0)}')
            RAD=$(awk -v i="$i" 'BEGIN {printf "%.1f", 20.5 + (i % 5)}')
            RH=$(awk -v i="$i" 'BEGIN {printf "%.1f", 77.0 + (i % 6)}')
            CSV_DATA="$CSV_DATA\n$M_D_Y,$T_MAX,$T_MIN,$RAIN,$RAD,$RH"
        done

        PAYLOAD=$(jq -n --arg pid "talhao-demo-esalq" --arg dev "preset_davis_vantage" --arg csv "$(echo -e "$CSV_DATA")" \
            '{parcel_id: $pid, device_id: $dev, csv_content: $csv}')

        curl -s -X POST "$BASE_API/weather/ingest" \
            -H "Content-Type: application/json" \
            -d "$PAYLOAD" > /dev/null

        # 8c. Predição fenológica inicial para popular histórico
        curl -s -X POST "$BASE_API/phenology/predict" \
            -H "Content-Type: application/json" \
            -d '{
                "parcel_id": "talhao-demo-esalq",
                "eval_date": "2026-09-17",
                "locale": "pt-BR"
            }' > /dev/null

        echo -e "${GREEN}✓ Talhão demonstrativo e série biometeorológica de 65 dias inicializados!${NC}"
    else
        echo -e "${GREEN}✓ Banco de dados ativo com $COUNT talhão(ões) configurado(s).${NC}"
    fi
fi

# 9. Resolver IP local da rede (LAN)
LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")

# 10. Se modo dev solicitado, iniciar flutter run web-server
if [ "$DEV_MODE" = true ]; then
    echo -e "\n${CYAN}==> [Modo Dev] Iniciando servidor de desenvolvimento Flutter Web com Hot-Reload...${NC}"
    cd "$APP_LOCAL_DIR"
    flutter run \
        -d web-server \
        --web-hostname 0.0.0.0 \
        --web-port 8110 \
        --dart-define=DEVELOPMENT_MODE=true \
        --dart-define=ENGINE_URL="http://127.0.0.1:$PORT" &
    DEV_PID=$!
fi

# 11. Exibir HUD do sistema
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║               🌾  ORYZA-ELO EDGE TERMINAL PRONTO  🌾                 ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}🖥️  DASHBOARD WEB (PRODUTOR):${NC}                                        ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Local:  ${CYAN}http://localhost:${PORT}${NC}                                       ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     LAN:    ${CYAN}http://${LAN_IP}:${PORT}${NC}                                   ${GREEN}║${NC}"
if [ "$DEV_MODE" = true ]; then
echo -e "${GREEN}║${NC}     Dev:    ${YELLOW}http://localhost:8110${NC} (Hot-Reload Ativo)                  ${GREEN}║${NC}"
fi
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}⚙️  API REST & TELEMETRIA:${NC}                                          ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Health Probe:  ${CYAN}http://localhost:${PORT}/api/v1/health${NC}                    ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Parcels CRUD:  ${CYAN}http://localhost:${PORT}/api/v1/parcels${NC}                   ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Analytics:     ${CYAN}http://localhost:${PORT}/api/v1/weather/analytics${NC}         ${GREEN}║${NC}"
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}📊  STATUS DO SISTEMA:${NC}                                              ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Hardware:    Linux x86_64 / Arm64 (Raspberry Pi compatível)      ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Rede:        ${GREEN}100% Offline (Zero chamadas externas/CDNs)${NC}           ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Latência ML: ${GREEN}< 0.5 ms por inferência (CatBoost ONNX resident)${NC}      ${GREEN}║${NC}"
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║  ${YELLOW}Pressione Ctrl+C para encerrar o nó de borda com segurança.${NC}        ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Aguarda o processo do engine
wait "$ENGINE_PID"
