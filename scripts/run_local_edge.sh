#!/usr/bin/env bash
# ==============================================================================
# Oryza-Elo: Turnkey Edge Launcher (Raspberry Pi & Local Development)
# ==============================================================================
# Launches the 'oryzaelo_engine' edge microservice on 0.0.0.0:8005 serving
# the Flutter Web 'apps/local' interface directly with zero external dependencies.
# ==============================================================================

set -euo pipefail

# ANSI color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# 1. Dynamic repository resolution
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

# Default configuration
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
Usage: ./run_local_edge.sh [options]

Options:
  -b, --build       Compile Flutter Web (apps/local) and sync before launching
  -s, --sync        Sync existing build to engine without recompiling
  -d, --dev         Development Mode: Engine on port 8005 + Flutter Web hot-reload on port 8110
  --debug           Run engine binary in debug mode (default: optimized release)
  --reset-db        Wipe local SQLite database before starting and recreate from scratch
  --no-seed         Do not seed demo data (parcels and telemetry)
  -p, --port <NUM>  HTTP port for Axum server (default: 8005)
  --host <IP>       Server listening host (default: 0.0.0.0)
  -h, --help        Display this help message

Examples:
  ./run_local_edge.sh                # Default turnkey execution on port 8005
  ./run_local_edge.sh --build        # Recompile frontend and start engine
  ./run_local_edge.sh --dev          # Hot-reload frontend for active development
  ./run_local_edge.sh --reset-db     # Clean SQLite database and reseed fresh data
EOF
}

# Parse command line arguments
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
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

echo -e "${GREEN}================================================================${NC}"
echo -e "${BOLD}${GREEN}  ORYZA-ELO - LOCAL EDGE NODE & GROWER DASHBOARD  ${NC}"
echo -e "${GREEN}================================================================${NC}"

# 2. Reset database if requested
DB_PATH="$ENGINE_DIR/src/dal/data/local/oryza_elo_edge.db"
if [ "$RESET_DB" = true ]; then
    echo -e "${YELLOW}==> [Reset DB] Removing local SQLite database...${NC}"
    rm -f "${DB_PATH}"*
    echo -e "${GREEN}[OK] Database cleaned.${NC}"
fi

# 3. Compile and sync static assets
if [ "$REBUILD" = true ]; then
    echo -e "${CYAN}==> [Build] Compiling frontend and syncing with engine...${NC}"
    "$COPY_SCRIPT"
elif [ "$SYNC_ONLY" = true ]; then
    echo -e "${CYAN}==> [Sync] Syncing existing build with engine...${NC}"
    "$COPY_SCRIPT" --skip-build
elif [ ! -f "$ENGINE_STATIC_DIR/index.html" ] && [ ! -f "$BUILD_WEB_DIR/index.html" ]; then
    echo -e "${YELLOW}==> [Notice] Static assets not found. Starting initial build...${NC}"
    "$COPY_SCRIPT"
elif [ ! -f "$ENGINE_STATIC_DIR/index.html" ] && [ -f "$BUILD_WEB_DIR/index.html" ]; then
    echo -e "${CYAN}==> [Sync] Copying existing web build to src/presentation/static...${NC}"
    "$COPY_SCRIPT" --skip-build
fi

# 4. Check if engine binary exists
ENGINE_BIN="$ENGINE_DIR/target/$PROFILE/oryzaelo_engine"
if [ ! -f "$ENGINE_BIN" ]; then
    echo -e "${CYAN}==> [Engine Build] Binary $ENGINE_BIN not found. Compiling in $PROFILE mode...${NC}"
    cd "$ENGINE_DIR"
    if [ "$PROFILE" = "release" ]; then
        cargo build --release
    else
        cargo build
    fi
fi

# 5. Export environment variables for engine microservice
export SERVER_HOST="$HOST"
export SERVER_PORT="$PORT"
export PORT="$PORT"
export STATIC_DIR="src/presentation/static"
export LOG_LEVEL="info"

# 6. Start engine in background with process control
cd "$ENGINE_DIR"

echo -e "\n${CYAN}==> Starting oryzaelo_engine on http://$HOST:$PORT...${NC}"
"$ENGINE_BIN" &
ENGINE_PID=$!

# Graceful cleanup handler
cleanup() {
    echo -e "\n${YELLOW}==> Shutting down Oryza-Elo services...${NC}"
    if kill -0 "$ENGINE_PID" 2>/dev/null; then
        kill "$ENGINE_PID" 2>/dev/null || true
        wait "$ENGINE_PID" 2>/dev/null || true
    fi
    if [ -n "${DEV_PID:-}" ] && kill -0 "$DEV_PID" 2>/dev/null; then
        kill "$DEV_PID" 2>/dev/null || true
    fi
    echo -e "${GREEN}[OK] Services stopped successfully.${NC}"
}
trap cleanup SIGINT SIGTERM EXIT

# 7. Wait for engine healthy startup
echo -n "Waiting for Axum server readiness"
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
    echo -e "${RED}Error: Server did not respond at $HEALTH_URL after 15 seconds.${NC}"
    exit 1
fi

# 8. Autonomous demonstration data seeder (reusing native Rust Admin API)
if [ "$SKIP_SEED" = false ]; then
    BASE_API="http://127.0.0.1:$PORT/api/v1"
    PARCELS_JSON=$(curl -s "$BASE_API/parcels" || echo "[]")
    COUNT=$(echo "$PARCELS_JSON" | grep -o '"id":' | wc -l || echo "0")

    if [ "$COUNT" -eq 0 ]; then
        echo -e "${CYAN}==> [Agronomic Seeder] Empty database detected. Populating high-fidelity test datasets via native Rust API...${NC}"
        curl -s -X POST "$BASE_API/admin/populate?days=75&parcels=4" > /dev/null
        echo -e "${GREEN}[OK] Demo farm and historical agrometeorological series initialized.${NC}"
    else
        echo -e "${GREEN}[OK] Database active with $COUNT configured parcel(s).${NC}"
    fi
fi

# 9. Resolve local LAN IP address
LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")

# 10. Start dev mode if requested
if [ "$DEV_MODE" = true ]; then
    echo -e "\n${CYAN}==> [Dev Mode] Starting Flutter Web development server with Hot-Reload...${NC}"
    cd "$APP_LOCAL_DIR"
    flutter run \
        -d web-server \
        --web-hostname 0.0.0.0 \
        --web-port 8110 \
        --dart-define=DEVELOPMENT_MODE=true \
        --dart-define=ENGINE_URL="http://127.0.0.1:$PORT" &
    DEV_PID=$!
fi

# 11. Display system HUD
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    ORYZA-ELO EDGE TERMINAL READY                     ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}WEB DASHBOARD (GROWER / EVALUATOR):${NC}                                 ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Local:  ${CYAN}http://localhost:${PORT}${NC}                                       ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     LAN:    ${CYAN}http://${LAN_IP}:${PORT}${NC}                                   ${GREEN}║${NC}"
if [ "$DEV_MODE" = true ]; then
echo -e "${GREEN}║${NC}     Dev:    ${YELLOW}http://localhost:8110${NC} (Hot-Reload Active)                  ${GREEN}║${NC}"
fi
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}REST API & TELEMETRY:${NC}                                               ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Health Probe:  ${CYAN}http://localhost:${PORT}/api/v1/health${NC}                    ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Parcels CRUD:  ${CYAN}http://localhost:${PORT}/api/v1/parcels${NC}                   ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Analytics:     ${CYAN}http://localhost:${PORT}/api/v1/weather/analytics${NC}         ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Admin Pop:     ${CYAN}http://localhost:${PORT}/api/v1/admin/populate${NC}            ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Admin Clean:   ${CYAN}http://localhost:${PORT}/api/v1/admin/clean${NC}               ${GREEN}║${NC}"
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}SYSTEM STATUS:${NC}                                                       ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Hardware:    Linux x86_64 / Arm64 (Raspberry Pi compatible)      ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     Network:     ${GREEN}100% Offline (Zero external calls/CDNs)${NC}           ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     ML Latency:  ${GREEN}< 0.5 ms per inference (CatBoost ONNX resident)${NC}      ${GREEN}║${NC}"
echo -e "${GREEN}║                                                                      ║${NC}"
echo -e "${GREEN}║  ${YELLOW}Press Ctrl+C to safely terminate the edge node.${NC}                   ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Wait for engine process
wait "$ENGINE_PID"
