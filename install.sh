#!/bin/bash

# =====================================
# Скрипт установки конфигурации Vim
# =====================================

set -e  # Остановиться при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода цветных сообщений
print_message() {
    echo -e "${2}${1}${NC}"
}

print_message "=====================================" "$BLUE"
print_message "   Установка конфигурации Vim" "$BLUE"
print_message "=====================================" "$BLUE"
echo

# Проверка наличия Vim
if ! command -v vim &> /dev/null; then
    print_message "❌ Vim не установлен!" "$RED"
    print_message "Установите Vim и запустите скрипт снова." "$YELLOW"
    echo
    echo "Для установки Vim используйте:"
    echo "  • macOS:    brew install vim"
    echo "  • Ubuntu:   sudo apt-get install vim"
    echo "  • CentOS:   sudo yum install vim"
    echo "  • Arch:     sudo pacman -S vim"
    exit 1
fi

print_message "✓ Vim найден: $(vim --version | head -n1)" "$GREEN"
echo

# Создание резервной копии существующего .vimrc
if [ -f "$HOME/.vimrc" ]; then
    BACKUP_FILE="$HOME/.vimrc.backup.$(date +%Y%m%d_%H%M%S)"
    print_message "📋 Найден существующий .vimrc" "$YELLOW"
    print_message "   Создаю резервную копию: $BACKUP_FILE" "$YELLOW"
    cp "$HOME/.vimrc" "$BACKUP_FILE"
    echo
fi

# Создание резервной копии директории .vim если существует
if [ -d "$HOME/.vim" ]; then
    BACKUP_DIR="$HOME/.vim.backup.$(date +%Y%m%d_%H%M%S)"
    print_message "📁 Найдена существующая директория .vim" "$YELLOW"
    print_message "   Создаю резервную копию: $BACKUP_DIR" "$YELLOW"
    cp -r "$HOME/.vim" "$BACKUP_DIR"
    echo
fi

# Копирование нового .vimrc
print_message "📦 Установка новой конфигурации..." "$BLUE"

# Получаем директорию скрипта
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ -f "$SCRIPT_DIR/.vimrc" ]; then
    cp "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
    print_message "✓ Конфигурация .vimrc установлена" "$GREEN"
else
    print_message "❌ Файл .vimrc не найден в директории скрипта!" "$RED"
    exit 1
fi

# Создание необходимых директорий
print_message "📁 Создание директорий Vim..." "$BLUE"
mkdir -p "$HOME/.vim/autoload"
mkdir -p "$HOME/.vim/backup"
mkdir -p "$HOME/.vim/colors"
mkdir -p "$HOME/.vim/plugged"
print_message "✓ Директории созданы" "$GREEN"
echo

# Установка vim-plug (менеджер плагинов) - опционально
read -p "Хотите установить vim-plug (менеджер плагинов)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_message "📦 Установка vim-plug..." "$BLUE"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || {
        print_message "⚠️  Не удалось установить vim-plug" "$YELLOW"
        print_message "   Вы можете установить его позже вручную" "$YELLOW"
    }
    
    if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
        print_message "✓ vim-plug установлен" "$GREEN"
        
        # Добавляем секцию для плагинов в .vimrc если её нет
        if ! grep -q "call plug#begin" "$HOME/.vimrc"; then
            cat >> "$HOME/.vimrc" << 'EOF'

" =====================================
" Плагины (vim-plug)
" =====================================
" Раскомментируйте и добавьте нужные плагины
" После добавления выполните :PlugInstall в Vim

" call plug#begin('~/.vim/plugged')
" 
" " Примеры популярных плагинов:
" " Plug 'preservim/nerdtree'          " Файловый менеджер
" " Plug 'vim-airline/vim-airline'     " Красивая статусная строка
" " Plug 'tpope/vim-fugitive'          " Git интеграция
" " Plug 'airblade/vim-gitgutter'      " Показ изменений git
" " Plug 'junegunn/fzf.vim'            " Fuzzy поиск
" " Plug 'tpope/vim-surround'          " Работа со скобками
" " Plug 'tpope/vim-commentary'        " Комментирование кода
" " Plug 'jiangmiao/auto-pairs'        " Автозакрытие скобок
" 
" call plug#end()
EOF
            print_message "✓ Добавлена секция для плагинов в .vimrc" "$GREEN"
        fi
    fi
    echo
fi

# Проверка работы конфигурации
print_message "🔍 Проверка конфигурации..." "$BLUE"
vim -c ':q' 2>/dev/null && {
    print_message "✓ Конфигурация работает корректно" "$GREEN"
} || {
    print_message "⚠️  Возможны проблемы с конфигурацией" "$YELLOW"
    print_message "   Проверьте сообщения об ошибках при запуске Vim" "$YELLOW"
}

echo
print_message "=====================================" "$GREEN"
print_message "    ✨ Установка завершена! ✨" "$GREEN"
print_message "=====================================" "$GREEN"
echo
print_message "📝 Полезные команды:" "$BLUE"
echo "  • Ctrl+O     - Файловый браузер"
echo "  • F3         - Режим вставки (для копирования из терминала)"
echo "  • Ctrl+S     - Сохранить"
echo "  • Ctrl+Q     - Выйти"
echo "  • Ctrl+A     - Выделить всё"
echo "  • Ctrl+C     - Копировать (в визуальном режиме)"
echo "  • Ctrl+V     - Вставить (в режиме вставки)"
echo "  • Ctrl+X     - Вырезать (в визуальном режиме)"
echo "  • Ctrl+Z     - Отменить"
echo "  • :help      - Справка Vim"
echo
print_message "🚀 Запустите 'vim' чтобы начать работу!" "$GREEN"