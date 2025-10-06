#!/bin/bash

# =====================================
# Быстрая установка Vim конфигурации
# Скачивание и установка одной командой
# =====================================

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    echo -e "${2}${1}${NC}"
}

print_message "=====================================" "$BLUE"
print_message "   Быстрая установка Vim config" "$BLUE"
print_message "=====================================" "$BLUE"
echo

# Временная директория для загрузки
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

print_message "📥 Загрузка конфигурации..." "$BLUE"

# Замените URL на ваш репозиторий GitHub
GITHUB_USER="ВАШ_GITHUB_USERNAME"
REPO_NAME="vim"

# Попытка загрузки через git
if command -v git &> /dev/null; then
    git clone "https://github.com/$GITHUB_USER/$REPO_NAME.git" "$TEMP_DIR/vim-config" 2>/dev/null || {
        print_message "⚠️  Не удалось клонировать репозиторий" "$YELLOW"
        print_message "   Проверьте URL: https://github.com/$GITHUB_USER/$REPO_NAME" "$YELLOW"
        exit 1
    }
    cd "$TEMP_DIR/vim-config"
else
    # Альтернатива - загрузка через curl/wget
    print_message "Git не найден, загружаю через curl..." "$YELLOW"
    
    if command -v curl &> /dev/null; then
        curl -L "https://github.com/$GITHUB_USER/$REPO_NAME/archive/main.zip" -o "$TEMP_DIR/vim-config.zip" || {
            print_message "❌ Не удалось загрузить архив" "$RED"
            exit 1
        }
    elif command -v wget &> /dev/null; then
        wget "https://github.com/$GITHUB_USER/$REPO_NAME/archive/main.zip" -O "$TEMP_DIR/vim-config.zip" || {
            print_message "❌ Не удалось загрузить архив" "$RED"
            exit 1
        }
    else
        print_message "❌ Необходим git, curl или wget для загрузки" "$RED"
        exit 1
    fi
    
    # Распаковка
    if command -v unzip &> /dev/null; then
        unzip -q "$TEMP_DIR/vim-config.zip" -d "$TEMP_DIR"
        cd "$TEMP_DIR/$REPO_NAME-main"
    else
        print_message "❌ Необходим unzip для распаковки" "$RED"
        exit 1
    fi
fi

print_message "✓ Конфигурация загружена" "$GREEN"
echo

# Запуск установщика
if [ -f "./install.sh" ]; then
    print_message "🚀 Запуск установщика..." "$BLUE"
    chmod +x ./install.sh
    ./install.sh
else
    # Если install.sh не найден, делаем базовую установку
    print_message "📦 Выполняю базовую установку..." "$BLUE"
    
    # Бэкап существующего .vimrc
    if [ -f "$HOME/.vimrc" ]; then
        cp "$HOME/.vimrc" "$HOME/.vimrc.backup.$(date +%Y%m%d_%H%M%S)"
        print_message "✓ Создана резервная копия .vimrc" "$GREEN"
    fi
    
    # Копирование .vimrc
    if [ -f "./.vimrc" ]; then
        cp "./.vimrc" "$HOME/.vimrc"
        print_message "✓ Установлен новый .vimrc" "$GREEN"
    else
        print_message "❌ Файл .vimrc не найден!" "$RED"
        exit 1
    fi
    
    # Создание директорий
    mkdir -p "$HOME/.vim/"{autoload,backup,colors,plugged}
    print_message "✓ Созданы директории Vim" "$GREEN"
    
    echo
    print_message "=====================================" "$GREEN"
    print_message "    ✨ Установка завершена! ✨" "$GREEN"
    print_message "=====================================" "$GREEN"
fi

echo
print_message "💡 Совет: Добавьте эту команду в закладки для быстрой установки на других машинах!" "$BLUE"