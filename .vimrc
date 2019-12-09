"-------------------------------------------------------
	" setting
"-------------------------------------------------------
	"文字コードをUFT-8に設定
	set fenc=utf-8
	scriptencoding utf-8
	" 保存時の文字コード
	set fileencoding=utf-8
	" 読み込み時の文字コードの自動判別. 左側が優先される
	set fileencodings=ucs-boms,utf-8,euc-jp,cp932
	" 改行コードの自動判別. 左側が優先される
	set fileformats=unix,dos,mac
	" □や○文字が崩れる問題を解決"
	set ambiwidth=double

	"ルーラー,行番号を表示
	set ruler
	set number

	" タイトルを表示
	set title
	set hls
	set nocompatible
	set confirm
	set autoread
	"2byte string
	set ambiwidth=double

	"行を折り返さない
	set nowrap
	set textwidth=0

	"ステータスラインにコマンドを表示
	set showcmd
	set clipboard=unnamed

	"括弧の対応をハイライト
	set showmatch
	set matchtime=1

	"自動インデントを有効化する
	set smartindent
	set autoindent
	set splitbelow
	" 行頭以外のTab文字の表示幅（スペースいくつ分）
	set tabstop=4
	" 行頭でのTab文字の表示幅
	set shiftwidth=4

	set nf=hex
	"set termguicolors

	"検索結果をハイライトする
	set hlsearch

	"C-vの矩形選択で行末より後ろもカーソルを置ける
	set virtualedit=block

	"[Backspace]キー有効化
	"set t_kb=
	"[DELETE]キー有効化
	"set t_kD=

	"ウィンドウを右に開く
	set splitright
	"エラー表示
	set errorformat+=
	\%d%*\\a[]%*\\d]:\ ディレクトリ\ '%f'\ に入ります,
	\%x%*\\a[]%*\\d]:\ ディレクトリ\ '%f'\ から出ます

	"vimdiffで空白を無視するset diffopt=iwhite
	set diffopt=iwhite
	"差分は単語ごとに表示する
	let g:diffunit = 'word1'

	"自動文字数カウント
	augroup WordCount
	    autocmd!
	    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
	augroup END
	let s:WordCountStr = ''
	let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
	function! WordCount(...)
		if a:0 == 0
			return s:WordCountStr
		endif
		let cidx = 3
		silent! let cidx = s:WordCountDict[a:1]
		let s:WordCountStr = ''
		let s:saved_status = v:statusmsg
		exec "silent normal! g\<c-g>"
		if v:statusmsg !~ '^--'
			let str = ''
			silent! let str = split(v:statusmsg, ';')[cidx]
			let cur = str2nr(matchstr(str, '\d\+'))
			let end = str2nr(matchstr(str, '\d\+\s*$'))
			if a:1 == 'char'
				" ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
				let cr = &ff == 'dos' ? 2 : 1
				let cur -= cr * (line('.') - 1)
				let end -= cr * line('$')
			endif
			let s:WordCountStr = printf('%d/%d', cur, end)
		endif
		let v:statusmsg = s:saved_status
		return s:WordCountStr
	endfunction

"------------------------------------------------------------------------
	" diffopt 設定
"------------------------------------------------------------------------
	" diffモードでの操作
	"   [c → 次の違いがある場所にジャンプ
	"   ]c → 前の違いがある場所にジャンプ
	"   do → 今開いているバッファに別バッファの差分を取り込む (:diffget)
	"   dp → 別バッファに今開いているバッファの差分を入れる   (:diffput)
	"
	"   http://qiita.com/purini-to/items/1209e467eb9ca73e529b
	if has("gui")
		" カレント行ハイライトON
		" 横方向。ただし Ubuntu 17.04 の nvim-qt はハイライトになるが、nvim では下線になるので注意。
		set cursorline
	endif
	" アンダーラインを引く(color terminal)
	"highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
	" アンダーラインを引く(gui)
	"highlight CursorLine gui=underline guifg=NONE guibg=NONE
	set diffopt+=filler     " 差分が無い箇所を '-' で埋めない
	set diffopt+=icase      " 大小文字の違いは無視する
	set diffopt+=iwhite     " 半角スペースの個数の違いは無視する
	set diffopt+=vertical
	nnoremap <C-c><C-c> ]c
	nnoremap <C-c><C-k> [c
	nnoremap <Leader>df :<C-u>diffsplit %
	nnoremap <Leader>do :<C-u>diffsplit %.orig <CR>
	"}}}

"-------------------------------------------------------
	" dein Scripts
"-------------------------------------------------------

	if &compatible
		set nocompatible
	endif
	" dein.vimのディレクトリ
	let s:dein_dir = expand('~/.cache/dein')
	let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
	
	" なければgit clone
	if !isdirectory(s:dein_repo_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
	endif
	execute 'set runtimepath^=' . s:dein_repo_dir
	
	if dein#load_state(s:dein_dir)
		call dein#begin(s:dein_dir)
	
		" 管理するプラグインを記述したファイル
		let s:toml = '~/.vim/dein/.dein.toml'
		let s:lazy_toml = '~/.vim/dein/.dein_lazy.toml'
		call dein#load_toml(s:toml, {'lazy': 0})
		call dein#load_toml(s:lazy_toml, {'lazy': 1})
		
		call dein#end()
		call dein#save_state()
	endif
	" プラグインの追加・削除やtomlファイルの設定を変更した後は
	" 適宜 call dein#update や call dein#clear_state を呼んでください。
	" そもそもキャッシュしなくて良いならload_state/save_stateを呼ばないようにしてください。
	
	" 2016.04.16 追記
	" load_cache -> load_state
	" save_cache -> save_state
	" となり書き方が少し変わりました。
	" 追記終わり
	
	" vimprocだけは最初にインストールしてほしい
	if dein#check_install(['vimproc'])
		call dein#install(['vimproc'])
	else
		call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
	endif
	" その他インストールしていないものはこちらに入れる
	if dein#check_install()
		call dein#install()
	endif

"-------------------------------------------------------
	" coloring
"-------------------------------------------------------
	syntax enable
	syntax on
	colorscheme jellybeans

	"tab & ret color
	set list
	set listchars=tab:>.,eol:<,trail:~,extends:»,precedes:«
"	hi NonText    ctermbg=None ctermfg=59 guibg=NONE guifg=None
"	hi SpecialKey ctermbg=None ctermfg=59 guibg=NONE guifg=None

	"ステータスラインを常に表示
	set laststatus=2
	" 常にタブラインを表示
	set showtabline=2
	" この設定がないと色が正しく表示されない
	set t_Co=256

	"ファイル名表示
	set statusline+=%<%F

	"ファイルナンバー表示
	set statusline=[%n]

	"変更のチェック表示
	set statusline+=%m

	"読み込み専用かどうか表示
	set statusline+=%r

	"ヘルプページなら[HELP]と表示
	set statusline+=%h

	"プレビューウインドウなら[Prevew]と表示
	set statusline+=%w

	"ファイルフォーマット表示
	set statusline+=[%{&fileformat}]

	"文字コード表示
	set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]

	"ファイルタイプ表示
	set statusline+=%y

"	" ステータスラインの表示(Git)
"	set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}  " fencとffを表示
	set statusline+=%y    " バッファ内のファイルのタイプ
	set statusline+=\     " 空白スペース
	if winwidth(0) >= 130
		set statusline+=%F    " バッファ内のファイルのフルパス
	else
		set statusline+=%t    " ファイル名のみ
	endif
"	set statusline+=%=    " 左寄せ項目と右寄せ項目の区切り
"	set statusline+=%{fugitive#statusline()}  " Gitのブランチ名を表示
"	set statusline+=\ \   " 空白スペース2個
"	set statusline+=%1l   " 何行目にカーソルがあるか
"	set statusline+=/
"	set statusline+=%L    " バッファ内の総行数
"	set statusline+=,
"	set statusline+=%c    " 何列目にカーソルがあるか
"	set statusline+=%V    " 画面上の何列目にカーソルがあるか
"	set statusline+=\ \   " 空白スペース2個
"	set statusline+=%P    " ファイル内の何％の位置にあるか

	"Airline
	let g:airline_powerline_fonts = 1

"	let g:airline_theme = 'jellybeans'
	" tab
"	let g:airline#extensions#tabline#enabled = 1
"	let g:airline#extensions#tabline#buffer_idx_mode = 1
"	let g:airline#extensions#tabline#buffer_idx_format = {
"		\ '0': '0 ',
"		\ '1': '1 ',
"		\ '2': '2 ',
"		\ '3': '3 ',
"		\ '4': '4 ',
"		\ '5': '5 ',
"		\ '6': '6 ',
"		\ '7': '7 ',
"		\ '8': '8 ',
"		\ '9': '9 '
"		\}
"	let g:airline#extensions#tabline#left_sep = '\'
"	let g:airline#extensions#tabline#left_alt_sep = '/'

	" mode
	let g:airline_mode_map = {
		\ 'n'  : 'Normal',
		\ 'i'  : 'Insert',
		\ 'R'  : 'Replace',
		\ 'c'  : 'Command',
		\ 'v'  : 'Visual',
		\ 'V'  : 'V-Line',
		\ '⌃V' : 'V-Block',
		\ }

	let g:airline#extensions#default#layout = [
		\ [ 'z', 'y', 'x' ],
		\ [ 'c', 'b', 'a', 'error', 'warning']
		\ ]
	let g:airline#extensions#tabline#left_sep = ' '
	let g:airline#extensions#tabline#left_alt_sep = '|'
	let g:airline#extensions#tabline#formatter = 'unique_tail'

	let g:airline_enable_branch = 0
	let g:airline_section_b = "%t %M"
	let g:airline_section_c = ''
	let s:sep = " %{get(g:, 'airline_right_alt_sep', '')} "
	let g:airline_section_x =
		\ "%{strlen(&fileformat)?&fileformat:''}".s:sep.
		\ "%{strlen(&fenc)?&fenc:&enc}".s:sep.
		\ "%{strlen(&filetype)?&filetype:'no ft'}"
	let g:airline_section_y = '%3p%%'
	let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
	let g:airline#extensions#whitespace#enabled = 0

	let g:airline#extensions#branch#enabled = 1
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#wordcount#enabled = 0
	let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]
	let g:airline_section_c = '%t'
	let g:airline_section_x = '%{&filetype}'
	let g:airline_section_z = '%3l:%2v %{airline#extensions#ale#get_warning()} %{airline#extensions#ale#get_error()}'
	let g:airline#extensions#ale#error_symbol = ' '
	let g:airline#extensions#ale#warning_symbol = ' '
	let g:airline#extensions#default#section_truncate_width = {}
	let g:airline#extensions#whitespace#enabled = 1

"	function! AccentDemo()
"		let keys = ['a','b','c','d','e','f','g','h']
"		for k in keys
"			call airline#parts#define_text(k, k)
"		endfor
"		call airline#parts#define_accent('a', 'red')
"		call airline#parts#define_accent('b', 'green')
"		call airline#parts#define_accent('c', 'blue')
"		call airline#parts#define_accent('d', 'yellow')
"		call airline#parts#define_accent('e', 'orange')
"		call airline#parts#define_accent('f', 'purple')
"		call airline#parts#define_accent('g', 'bold')
"		call airline#parts#define_accent('h', 'italic')
"		let g:airline_section_a = airline#section#create(keys)
"	endfunction
"	autocmd VimEnter * call AccentDemo()

	"デフォルトのZenkakuSpaceを定義
	function! ZenkakuSpace()
		highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
	endfunction

	if has('syntax')
		augroup ZenkakuSpace
			autocmd!
			" ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
			autocmd ColorScheme       * call ZenkakuSpace()
			" 全角スペースのハイライト指定
			autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
			autocmd VimEnter,WinEnter * match ZenkakuSpace '\%u3000'
		augroup END
	call ZenkakuSpace()
	endif

	" https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
	function! GetCharCode()
		" Get the output of :ascii
		redir => ascii
		silent! ascii
		redir END
	
		if match(ascii, 'NUL') != -1
			return 'NUL'
		endif
	
		" Zero pad hex values
		let nrformat = '0x%02x'
	
		let encoding = (&fenc == '' ? &enc : &fenc)
	
		if encoding == 'utf-8'
			" Zero pad with 4 zeroes in unicode files
			let nrformat = '0x%04x'
		endif
	
		" Get the character and the numeric value from the return value of :ascii
		" This matches the two first pieces of the return value, e.g.
		" "<F>  70" => char: 'F', nr: '70'
		let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')
	
		" Format the numeric value
		let nr = printf(nrformat, nr)
	
		return "'". char ."' ". nr
	endfunction

	function! GetEncoding()
		let fenc = strlen(&fenc) >0 ? &fenc : ''
		let ff = strlen(&ff) > 0 ? &ff : ''
		return fenc . '[' . ff . ']'
	endfunction

	" Display charcode, fileencoding and fileformat.
	let g:airline_section_y = '%{GetCharCode()} %{g:airline_right_alt_sep} %{GetEncoding()}'

"-------------------------------------------------------
	" Plugin:ale
"-------------------------------------------------------
	" 保存時のみ実行する
	let g:ale_lint_on_text_changed = 0
	" 表示に関する設定
	let g:ale_sign_error = ''
	let g:ale_sign_warning = ''
	let g:airline#extensions#ale#open_lnum_symbol = '('
	let g:airline#extensions#ale#close_lnum_symbol = ')'
	let g:ale_echo_msg_format = '[%linter%]%code: %%s'
	highlight link ALEErrorSign Tag
	highlight link ALEWarningSign StorageClass
	" Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
	nmap <silent> <C-k> <Plug>(ale_previous_wrap)
	nmap <silent> <C-j> <Plug>(ale_next_wrap)

"-------------------------------------------------------
	" Keyconfig
"-------------------------------------------------------

	" Don't yank with 'x' and 's'
	nnoremap x "_x
	nnoremap s "_s

	" 検索した後に移動しない
	nnoremap * *N
	nnoremap # #N

	set timeoutlen=300
	noremap! ;; <ESC>

	noremap j k
	noremap k j
	noremap <S-h> <Home>
	noremap <S-j> <PageUp>
	noremap <S-k> <PageDown>
	noremap <S-l> <End>

	inoremap <C-h> <Left>
	inoremap <C-j> <Up>
	inoremap <C-k> <Down>
	inoremap <C-l> <Right>

	cnoremap <C-h> <Left>
	cnoremap <C-j> <Up>
	cnoremap <C-k> <Down>
	cnoremap <C-l> <Right>

	noremap w b

	nnoremap r <S-r>

	nnoremap <silent> <space><space> "zyiw:let @/ = '\<' . @z . '\>'<cr>:set hlsearch<CR>
	nmap :: :nohlsearch<CR>

	if has('nvim')
		" For Neovim
		autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
	else
		" For Vim
		autocmd WinEnter * if &buftype ==# 'terminal' | normal i | endif
	endif

	tnoremap ;; <C-\><C-n>
	tnoremap <S-w><S-w> <C-\><C-n><C-w><C-w>

	" Plugin
	" YouCompleteMe
	let g:ycm_global_ycm_extra_conf = '~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"-------------------------------------------------------
	" Function
"-------------------------------------------------------

	" View hex
	noremap <F2> :echo expand("%:p")<CR>
	" Wake up terminal mode
	noremap <F8> :terminal<CR>
	" View class list
	noremap <F9> :tagbartoggle<CR>
	" Table
	let g:table_mode_corner = '|'
"	:TableModeToggle

	let g:sonictemplate_vim_template_dir = ['~/.vim/template']
"	:Template [x]

	let g:cheatsheet#cheat_file = '~/.cheatsheet.md'

	" Window resize
	let g:winresizer_vert_resize = 1
	let g:winresizer_horiz_resize = 1
"	noremap <C-e>

	"Git command
"	nmap :Gblame<CR>
