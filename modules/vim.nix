{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-easymotion
      vim-airline
      vim-airline-themes
      undotree
    ];
    extraConfig = ''
      filetype off
      set nocompatible
      let mapleader=" "
      syntax on
      filetype plugin indent on 
      set ts=4
      set autoindent
      set expandtab
      set shiftwidth=4
      set showmatch
      let python_highlight_all = 1
      au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
      autocmd FileType yaml setlocal ts=3 sts=2 sw=2 expandtab
      set hidden
      set cursorline
      hi CursorLine guibg=Gray21
      hi EasyMotionTargetDefault guifg=Green
      hi Visual term=reverse cterm=reverse guibg=Gray29
      let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'
      let g:auto_save = 1
      let g:ctrlp_cmd = 'CtrlPBuffer'
      set wildmenu
      set wildmode=longest:full
      set guioptions=egm
      set sidescroll=1
      set mouse=a
      let g:netrw_list_hide= '.*\.swp$'
      let g:vim_markdown_folding_disabled = 1
      let g:vim_markdown_new_list_item_indent = 4
      autocmd BufWritePre *.py execute ':Black'
      au! BufNewFile,BufReadPost *.md set formatoptions+=a
      let g:workspace_session_disable_on_args = 1
      let g:workspace_autosave = 0
      set autoread
      map <Leader> <Plug>(easymotion-prefix)
    '';
  };
}
