#!/bin/bash

# =====================================
# Web-установщик Vim конфигурации
# Для запуска через curl/wget
# =====================================

set -e

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_message() {
    echo -e "${2}${1}${NC}"
}

# Баннер
clear
echo -e "${CYAN}"
cat << "EOF"
 __     ___           ____             __ _       
 \ \   / (_)_ __ ___ / ___|___  _ __  / _(_) __ _ 
  \ \ / /| | '_ ` _ \| |   / _ \| '_ \| |_| |/ _` |
   \ V / | | | | | | | |__| (_) | | | |  _| | (_| |
    \_/  |_|_| |_| |_|\____\___/|_| |_|_| |_|\__, |
                                              |___/ 
EOF
echo -e "${NC}"

print_message "=====================================" "$BLUE"
print_message "   Автоматическая установка" "$BLUE"
print_message "=====================================" "$BLUE"
echo

# Проверка Vim
if ! command -v vim &> /dev/null; then
    print_message "❌ Vim не установлен!" "$RED"
    echo
    read -p "Установить Vim автоматически? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Определение ОС и установка
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install vim
            else
                print_message "❌ Homebrew не найден. Установите Vim вручную." "$RED"
                exit 1
            fi
        elif [[ -f /etc/debian_version ]]; then
            sudo apt-get update && sudo apt-get install -y vim
        elif [[ -f /etc/redhat-release ]]; then
            sudo yum install -y vim
        elif [[ -f /etc/arch-release ]]; then
            sudo pacman -S --noconfirm vim
        else
            print_message "❌ Не удалось определить ОС для автоматической установки" "$RED"
            exit 1
        fi
    else
        exit 1
    fi
fi

print_message "✓ Vim найден" "$GREEN"

# Временная директория
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

cd "$TEMP_DIR"

print_message "📥 Загрузка конфигурации..." "$BLUE"

# Создание .vimrc
cat > ".vimrc" << 'VIMRC_EOF'
" =====================================
" Удобная конфигурация Vim
" =====================================

" Основные настройки
set nocompatible              " Отключить совместимость с vi
set encoding=utf-8            " UTF-8 по умолчанию
set fileencoding=utf-8
set termencoding=utf-8

" Нумерация строк
set number                    " Показывать номера строк
set norelativenumber         " Отключить относительную нумерацию
" Работа с мышью
set mouse=a                   " Включить поддержку мыши во всех режимах
set ttymouse=sgr              " Поддержка мыши в больших терминалах
set selectmode=mouse          " Выделение мышью

" Отображение
syntax on                     " Подсветка синтаксиса
set title                     " Показывать имя файла в заголовке окна
set ruler                     " Показывать позицию курсора
set showcmd                   " Показывать вводимые команды
set showmode                  " Показывать текущий режим
set laststatus=2              " Всегда показывать статусную строку
set wildmenu                  " Автодополнение команд
set wildmode=list:longest,full

" Красивая статусная строка с информацией о файле
set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %{mode()}\ 
set statusline+=%#LineNr#
set statusline+=\ %F            " Полный путь к файлу
set statusline+=\ %m             " Модифицирован?
set statusline+=\ %r             " Только для чтения?
set statusline+=%=               " Переход на правую сторону
set statusline+=%#CursorColumn#
set statusline+=\ %Y             " Тип файла
set statusline+=\ [%{&fileencoding?&fileencoding:&encoding}]
set statusline+=\ [%{&fileformat}]
set statusline+=\ %p%%           " Процент в файле
set statusline+=\ %l:%c          " Строка:Колонка
set statusline+=\ 

" Поиск
set hlsearch                  " Подсвечивать результаты поиска
set incsearch                 " Инкрементальный поиск
set ignorecase                " Игнорировать регистр при поиске
set smartcase                 " Умный поиск с учётом регистра

" Отступы и табуляция
set expandtab                 " Пробелы вместо табов
set tabstop=4                 " Размер табуляции
set shiftwidth=4              " Размер отступа
set softtabstop=4
set autoindent                " Автоотступ
set smartindent               " Умные отступы

" Редактирование
set backspace=indent,eol,start " Нормальная работа backspace
set clipboard=unnamed         " Использовать системный буфер обмена
if has('unnamedplus')
    set clipboard+=unnamedplus
endif

" Визуальные подсказки
set cursorline                " Подсветка текущей строки
set colorcolumn=80            " Вертикальная линия на 80 символе
set wrap                      " Перенос длинных строк
set linebreak                 " Перенос по словам

" История и бэкапы
set history=1000              " Большая история команд
set undolevels=1000           " Много уровней отмены
set nobackup                  " Не создавать резервные копии
set noswapfile                " Не создавать swap файлы

" Удобные сочетания клавиш
" Ctrl+C для копирования в визуальном режиме
vnoremap <C-c> "+y
" Ctrl+V для вставки в режиме вставки
inoremap <C-v> <Esc>"+pa
" Ctrl+X для вырезания в визуальном режиме
vnoremap <C-x> "+d
" Delete для удаления выделенного
vnoremap <Del> d
vnoremap <BS> d

" Ctrl+A для выделения всего
nnoremap <C-a> ggVG

" Сохранение через Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Выход через Ctrl+Q
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>

" Отмена через Ctrl+Z
nnoremap <C-z> u
inoremap <C-z> <Esc>ui

" Повтор через Ctrl+Y
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>i

" Навигация между окнами с Ctrl+стрелки
nnoremap <C-Left> <C-w>h
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k
nnoremap <C-Right> <C-w>l

" Более удобная навигация по длинным строкам
nnoremap j gj
nnoremap k gk

" Быстрое перемещение между ошибками
nnoremap <F8> :cnext<CR>
nnoremap <F7> :cprev<CR>

" Очистка подсветки поиска по Esc
nnoremap <Esc> :noh<CR><Esc>

" Автокоманды
augroup vimrc
    autocmd!
    " Возврат на последнюю позицию при открытии файла
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
    " Автоматическое удаление пробелов в конце строк при сохранении
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Цветовая схема (если доступна)
silent! colorscheme desert
set background=dark

" Включить 256 цветов в терминале
if &term =~ '256color'
    set t_Co=256
endif

" Подсветка лишних пробелов
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Файловый браузер netrw
let g:netrw_banner = 0       " Скрыть баннер
let g:netrw_liststyle = 3    " Древовидное отображение
let g:netrw_browse_split = 4 " Открывать в предыдущем окне
let g:netrw_winsize = 20      " Размер окна браузера

" F2 для переключения файлового браузера
nnoremap <F2> :Lexplore<CR>

" F3 для переключения режима вставки/замены
set pastetoggle=<F3>

" Улучшенное автодополнение
set completeopt=menu,menuone,noselect

" Показывать непечатаемые символы
set list
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹,nbsp:·

" Плавная прокрутка
set scrolloff=8               " Минимум строк сверху/снизу от курсора
set sidescrolloff=15          " Минимум символов слева/справа

" Сообщения
set shortmess+=c              " Не показывать сообщения о дополнении

" Включить matchit для улучшенного % навигации
runtime macros/matchit.vim
VIMRC_EOF

print_message "✓ Конфигурация подготовлена" "$GREEN"

# Резервное копирование
if [ -f "$HOME/.vimrc" ]; then
    BACKUP_FILE="$HOME/.vimrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.vimrc" "$BACKUP_FILE"
    print_message "📋 Создана резервная копия: $BACKUP_FILE" "$YELLOW"
fi

# Установка
print_message "📦 Установка конфигурации..." "$BLUE"

cp ".vimrc" "$HOME/.vimrc"
mkdir -p "$HOME/.vim/"{autoload,backup,colors,plugged}

print_message "✓ Конфигурация установлена" "$GREEN"

# Опциональная установка vim-plug
echo
read -p "Установить vim-plug для управления плагинами? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null && {
        print_message "✓ vim-plug установлен" "$GREEN"
    } || {
        print_message "⚠️  Не удалось установить vim-plug" "$YELLOW"
    }
fi

echo
print_message "=====================================" "$GREEN"
print_message "    ✨ Установка завершена! ✨" "$GREEN"
print_message "=====================================" "$GREEN"
echo
echo -e "${CYAN}Горячие клавиши:${NC}"
echo "  • F2         - Файловый браузер"
echo "  • Ctrl+S     - Сохранить"
echo "  • Ctrl+Q     - Выйти"
echo "  • Ctrl+C/V/X - Копировать/Вставить/Вырезать"
echo "  • Ctrl+A     - Выделить всё"
echo
print_message "🚀 Запустите 'vim' для начала работы!" "$GREEN"
