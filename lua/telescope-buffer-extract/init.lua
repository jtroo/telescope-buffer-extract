local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local set_plus_register = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    actions.close(prompt_bufnr)
    return
  end
  vim.fn.setreg("+", selection.value)
  actions.close(prompt_bufnr)
end

local put = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    actions.close(prompt_bufnr)
    return
  end
  actions.close(prompt_bufnr)
  vim.schedule(function()
    vim.api.nvim_put({selection.value}, "", true, true)
  end)
end

local pick = function(title, opts, results)
  local finder = finders.new_table {
    results = results,
  }
  if opts.no_insert_mode ~= true then
    finder.close = function()
      vim.schedule(function()
        vim.cmd [[startinsert]]
      end)
    end
  end
  pickers.new({}, {
    prompt_title = title,
    finder = finder,
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(set_plus_register)
      map("i", "<Tab>", put)
      map("n", "<Tab>", put)
      return true
    end,
  }):find()
end

local pick_word = function(opts)
  opts = opts or {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local results = {} -- all words
  for i = #lines,1,-1 do
    local line = lines[i]
    for word in line:gmatch("%S+") do
      if #word > 0 then
        table.insert(results, word)
      end
    end
  end
  pick("Pick word - Tab: paste, Enter: copy to clipboard", opts, results)
end

local pick_line = function(opts)
  opts = opts or {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local results = {} -- all lines, skipping empty ones
  for i = #lines,1,-1 do
    local line = lines[i]
    if #line > 0 then
      table.insert(results, line)
    end
  end
  pick("Pick line - Tab: paste, Enter: copy to clipboard", opts, results)
end

return {
  pick_word = pick_word,
  pick_line = pick_line,
}
