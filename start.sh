#!/bin/bash

# Fintech Demo - One-click startup script
# Starts both backend (Spring Boot) and frontend (Flutter) applications

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "  Fintech Demo - Starting Application"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Stop existing services before starting
stop_existing_services() {
    echo "[Cleanup] Checking for existing services..."

    # Stop backend if PID file exists
    if [ -f /tmp/fintech-backend.pid ]; then
        OLD_PID=$(cat /tmp/fintech-backend.pid)
        if kill -0 $OLD_PID 2>/dev/null; then
            echo "[Cleanup] Stopping existing backend (PID: $OLD_PID)..."
            kill $OLD_PID 2>/dev/null || true
            sleep 2
        fi
        rm -f /tmp/fintech-backend.pid
    fi

    # Check if port 8080 is still in use and kill the process
    PORT_PID=$(lsof -ti:8080 2>/dev/null || true)
    if [ -n "$PORT_PID" ]; then
        echo "[Cleanup] Port 8080 is in use (PID: $PORT_PID), stopping..."
        kill $PORT_PID 2>/dev/null || true
        sleep 2
        # Force kill if still running
        if lsof -ti:8080 &>/dev/null; then
            kill -9 $(lsof -ti:8080) 2>/dev/null || true
            sleep 1
        fi
    fi

    # Stop frontend app if running
    FRONTEND_PID=$(pgrep -f "fintech_demo" 2>/dev/null || true)
    if [ -n "$FRONTEND_PID" ]; then
        echo "[Cleanup] Stopping existing frontend app (PID: $FRONTEND_PID)..."
        kill $FRONTEND_PID 2>/dev/null || true
        sleep 1
    fi

    echo -e "${GREEN}[Cleanup] Done!${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    echo "[Prerequisites] Checking required tools..."

    if ! command -v java &> /dev/null; then
        echo -e "${RED}Error: Java is not installed${NC}"
        exit 1
    fi

    if ! command -v mvn &> /dev/null; then
        echo -e "${RED}Error: Maven is not installed${NC}"
        exit 1
    fi

    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}Error: Flutter is not installed${NC}"
        exit 1
    fi

    echo -e "${GREEN}All prerequisites met!${NC}"
    echo ""
}

# Start backend
start_backend() {
    echo "[Backend] Starting Spring Boot server..."
    cd "$SCRIPT_DIR/fintech-backend-demo"

    # Run in background and save PID
    mvn spring-boot:run > /tmp/backend.log 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID > /tmp/fintech-backend.pid

    # Wait for backend to be ready
    echo "[Backend] Waiting for server to start..."
    for i in {1..30}; do
        if curl -s http://localhost:8080/api/users > /dev/null 2>&1; then
            echo -e "${GREEN}[Backend] Server started successfully on http://localhost:8080${NC}"
            return 0
        fi
        sleep 1
    done

    echo -e "${YELLOW}[Backend] Server may still be starting, check /tmp/backend.log for details${NC}"
}

# Start frontend
start_frontend() {
    echo ""
    echo "[Frontend] Building and launching Flutter app..."
    cd "$SCRIPT_DIR/fintech-flutter-demo"

    # Install dependencies
    echo "[Frontend] Installing dependencies..."
    flutter pub get

    # Prepare macOS platform files (generate ephemeral directory)
    echo "[Frontend] Preparing macOS platform files..."
    flutter create . --platforms=macos 2>/dev/null || true
    # Trigger ephemeral file generation (ignore failures due to arch issues)
    flutter build macos --debug 2>/dev/null || true

    # Build with Xcode for x86_64 architecture (Rosetta compatibility)
    echo "[Frontend] Building macOS app..."
    cd macos
    xcodebuild -project Runner.xcodeproj \
        -scheme Runner \
        -configuration Debug \
        -destination 'platform=macOS,arch=x86_64' \
        build -quiet

    # Find and launch the app
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "fintech_demo.app" -path "*/Debug/*" -type d 2>/dev/null | head -1)
    if [ -n "$APP_PATH" ]; then
        open "$APP_PATH"
        echo -e "${GREEN}[Frontend] App launched successfully!${NC}"
    else
        echo -e "${RED}[Frontend] Error: Could not find built app${NC}"
        exit 1
    fi
}

# Cleanup function
cleanup() {
    echo ""
    echo "[Cleanup] Stopping services..."
    if [ -f /tmp/fintech-backend.pid ]; then
        kill $(cat /tmp/fintech-backend.pid) 2>/dev/null || true
        rm /tmp/fintech-backend.pid
    fi
    echo "Done."
}

# Main
trap cleanup EXIT

stop_existing_services
check_prerequisites
start_backend
start_frontend

echo ""
echo "=========================================="
echo -e "${GREEN}  Application started successfully!${NC}"
echo "=========================================="
echo ""
echo "  Backend:  http://localhost:8080"
echo "  H2 Console: http://localhost:8080/h2-console"
echo "  Frontend: fintech_demo.app (macOS)"
echo ""
echo "Press Ctrl+C to stop all services..."
echo ""

# Keep script running to maintain backend
wait $BACKEND_PID
