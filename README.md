# Telescope buffer extract

## What does this do?

This allows you to fuzzy-select a word or line from the current buffer using
telescope and then either paste the selection at the current position, or copy
the selection to your clipboard.

The inspiration for this plugin came from the tmux
[extrakto](https://github.com/laktak/extrakto) plugin. The reason I created
this was for better ergonomics in the Neovim terminal for the use case of
pasting terminal output back into the terminal input, or copying terminal
output for use elsewhere.

## Installation

I have no idea how modern-day Neovim installation works. I still use pathogen
with vendored plugins. Using pathogen, git clone into the `bundle` directory.

## How to use

This plugin automatically adds two new commands that open a pickers. After the
telescope picker closes, you will automatically go back to insert or terminal
mode, depending on the active buffer. This is the default behaviour, but can be
overridden.

    :TelescopeBufferExtractWord
    :TelescopeBufferExtractLine

Alternatively, with Lua:

    :lua require'telescope-buffer-extract'.pick_word()
    :lua require'telescope-buffer-extract'.pick_line()

If you do not want to enter insert mode after running the functions, add `true`.

    :lua require'telescope-buffer-extract'.pick_word({no_insert_mode = true})
    :lua require'telescope-buffer-extract'.pick_line({no_insert_mode = true})

With the picker open, pressing `Tab` will paste the selection at the cursor's
current location. Pressing `Enter` will copy the selection into the `+`
register (usually the OS clipboard).

## How I (jtroo) use it

I use the Neovim terminal only when I'm working in Windows, otherwise on Linux
I'm using tmux. I have some keybindings to emulate tmux workflows inside the
Neovim terminal. The ones calling this plugin in particular are:

    " like tmux extrakto, by word
    tnoremap <c-b><tab> <c-\><c-n>:TelescopeBufferExtractWord<cr>
    " like tmux extrakto, by line
    tnoremap <c-b>` <c-\><c-n>:TelescopeBufferExtractLine<cr>

These are terminal-mode mappings (like insert, but within a terminal) which
will open the picker and then go back to to terminal-mode once a selection is
made.

## Known bugs

The picker does not go back into terminal mode if cancelled, e.g. pressing
`<C-c>` instead of Tab or Enter.
