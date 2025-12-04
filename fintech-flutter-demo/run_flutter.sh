#!/bin/bash

# Flutter macOS 构建和运行脚本
# 用于解决 Intel Mac 上的架构兼容性问题

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Flutter macOS 构建脚本 ===${NC}"

# 显示帮助
show_help() {
    echo "用法: ./run_flutter.sh [选项]"
    echo ""
    echo "选项:"
    echo "  clean     清理构建缓存并重新构建"
    echo "  build     仅构建应用（不运行）"
    echo "  run       构建并运行应用（默认）"
    echo "  open      打开已构建的应用"
    echo "  help      显示此帮助信息"
    echo ""
}

# 清理构建缓存
clean_build() {
    echo -e "${YELLOW}正在清理构建缓存...${NC}"
    flutter clean
    flutter pub get
    echo -e "${GREEN}清理完成！${NC}"
}

# 构建应用
build_app() {
    echo -e "${YELLOW}正在构建 macOS 应用...${NC}"
    arch -x86_64 flutter build macos
    echo -e "${GREEN}构建完成！${NC}"
    echo -e "应用位置: ${SCRIPT_DIR}/build/macos/Build/Products/Release/fintech_demo.app"
}

# 运行应用
run_app() {
    APP_PATH="${SCRIPT_DIR}/build/macos/Build/Products/Release/fintech_demo.app"
    if [ -d "$APP_PATH" ]; then
        echo -e "${YELLOW}正在启动应用...${NC}"
        open "$APP_PATH"
        echo -e "${GREEN}应用已启动！${NC}"
    else
        echo -e "${RED}应用不存在，请先构建！${NC}"
        exit 1
    fi
}

# 主逻辑
case "${1:-run}" in
    clean)
        clean_build
        build_app
        run_app
        ;;
    build)
        build_app
        ;;
    run)
        if [ ! -d "${SCRIPT_DIR}/build/macos/Build/Products/Release/fintech_demo.app" ]; then
            echo -e "${YELLOW}应用尚未构建，正在构建...${NC}"
            build_app
        fi
        run_app
        ;;
    open)
        run_app
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}未知选项: $1${NC}"
        show_help
        exit 1
        ;;
esac
