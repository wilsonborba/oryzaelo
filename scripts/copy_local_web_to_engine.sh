#!/usr/bin/env bash
# ==============================================================================
# Oryza-Elo: Build & Sync Local Dashboard to Engine
# ==============================================================================
# Compiles the Flutter Web application 'apps/local' and copies static assets
# directly to 'oryzaelo_engine/src/presentation/static'.
# ==============================================================================

set -euo pipefail

# ANSI color palette
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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
            echo "Usage: ./scripts/copy_local_web_to_engine.sh [options]"
            echo ""
            echo "Options:"
            echo "  -s, --skip-build    Skip Flutter compilation and only copy the existing build"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option: $arg${NC}"
            exit 1
            ;;
    esac
done

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}  Oryza-Elo - Local Frontend -> Edge Engine Synchronizer  ${NC}"
echo -e "${CYAN}================================================================${NC}"
echo -e "Frontend: ${YELLOW}$APP_LOCAL_DIR${NC}"
echo -e "Engine:   ${YELLOW}$ENGINE_STATIC_DIR${NC}"

# 2. Compile Flutter Web if required
if [ "$SKIP_BUILD" = false ]; then
    echo -e "\n${CYAN}==> [1/3] Compiling Flutter Web in release mode (apps/local)...${NC}"
    cd "$APP_LOCAL_DIR"
    BKK_TIMESTAMP=$(TZ="Asia/Bangkok" date +"%Y-%m-%d %H:%M +07")
    flutter build web --release \
        --dart-define=BUILD_TIMESTAMP="$BKK_TIMESTAMP"
else
    echo -e "\n${YELLOW}==> [1/3] Skipping compilation (--skip-build selected)...${NC}"
    if [ ! -f "$BUILD_WEB_DIR/index.html" ]; then
        echo -e "${RED}Error: File $BUILD_WEB_DIR/index.html not found. Run without --skip-build to compile.${NC}"
        exit 1
    fi
fi

# 3. Prepare target directory in engine
echo -e "\n${CYAN}==> [2/3] Preparing target directory in engine...${NC}"
mkdir -p "$ENGINE_STATIC_DIR"
# Clean previous files to prevent orphaned assets from older builds
rm -rf "$ENGINE_STATIC_DIR"/*

# 4. Copy compiled assets
echo -e "\n${CYAN}==> [3/3] Copying compiled web bundle to engine...${NC}"
cp -r "$BUILD_WEB_DIR"/* "$ENGINE_STATIC_DIR"/

# 5. Integrity validation of copied bundle
CRITICAL_FILES=("index.html" "main.dart.js" "flutter.js" "canvaskit" "assets")
MISSING=0
for item in "${CRITICAL_FILES[@]}"; do
    if [ ! -e "$ENGINE_STATIC_DIR/$item" ]; then
        echo -e "${RED}  [MISSING] $item${NC}"
        MISSING=$((MISSING + 1))
    else
        echo -e "${GREEN}  [OK] $item${NC}"
    fi
done

if [ "$MISSING" -gt 0 ]; then
    echo -e "\n${RED}Error: $MISSING essential item(s) not found after copy.${NC}"
    exit 1
fi

TOTAL_FILES=$(find "$ENGINE_STATIC_DIR" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$ENGINE_STATIC_DIR" | cut -f1)

# 6. Verify .env configuration in engine
ENGINE_ENV_FILE="$ENGINE_DIR/.env"
if [ -f "$ENGINE_ENV_FILE" ]; then
    if ! grep -q "^STATIC_DIR=" "$ENGINE_ENV_FILE"; then
        echo -e "\n${YELLOW}Note: Adding STATIC_DIR=src/presentation/static in $ENGINE_ENV_FILE${NC}"
        echo "STATIC_DIR=src/presentation/static" >> "$ENGINE_ENV_FILE"
    else
        sed -i 's|^STATIC_DIR=.*|STATIC_DIR=src/presentation/static|' "$ENGINE_ENV_FILE"
    fi
fi

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}Synchronization completed successfully.${NC}"
echo -e "  Files copied:  ${YELLOW}$TOTAL_FILES${NC}"
echo -e "  Total size:    ${YELLOW}$TOTAL_SIZE${NC}"
echo -e "  Static target: ${YELLOW}$ENGINE_STATIC_DIR${NC}"
echo -e "${GREEN}================================================================${NC}"
echo -e "You can now start the engine on port 8005 to serve the offline application."
