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

" Ctrl+O для переключения файлового браузера
nnoremap <C-o> :Lexplore<CR>

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
