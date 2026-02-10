{ pkgs, ... }:
let
  # Build vim-hardmode (since it is not in nixpkgs)
  vim-hardmode = pkgs.vimUtils.buildVimPlugin {
    name = "vim-hardmode";
    src = pkgs.fetchFromGitHub {
      owner = "dusans";
      repo = "vim-hardmode";
      rev = "6ae6510839e31d418ee4eb2b036c05d09b671a5f";
      sha256 = "sha256-429+sW2L+5V1wS4g/u8H+zL7T/4vT5yZlR0P5zJ+zZg=";
    };
  };
in
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      vim-hardtime            # takac/vim-hardtime
      markdown-preview-nvim   # iamcco/markdown-preview.vim
      vim-hardmode            # Your custom plugin
    ];

    extraConfig = ''
      let mapleader = " "

      " let g:hardtime_default_on = 1

      nnoremap <Space> <Nop>
      nnoremap <silent> <leader>gd <C-]>

      set nocompatible
      filetype on
      set relativenumber
      set number
      set scrolloff=8

      set hlsearch
      set incsearch

      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set smartindent

      set t_Co=256
      colorscheme lunaperche
      highlight Normal ctermbg=NONE guibg=NONE

      set wildmenu
      syntax on

      " Auto-closing mappings
      inoremap [ []<Left>
      inoremap ( ()<Left>
      inoremap " ""<Left>
      inoremap ' ''<Left>
      inoremap {<CR> {<CR>}<Esc>O
      inoremap { {}<Left>

      set clipboard=unnamedplus
      set ignorecase
      set smartcase
      set tags=./tags;,tags;
    '';
  };
}
