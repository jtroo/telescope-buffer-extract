" Title:        Telescope buffer word/line extractor
"
" Description:  A plugin that exposes functions to paste or copy words or lines
"               from the current buffer.
"
" Maintainer:   jtroo

if exists("g:loaded_telescopebufferextract")
    finish
endif
let g:loaded_telescopebufferextract = 1

command! -nargs=* TelescopeBufferExtractLine lua require("telescope-buffer-extract").pick_line()
command! -nargs=* TelescopeBufferExtractWord lua require("telescope-buffer-extract").pick_word()
