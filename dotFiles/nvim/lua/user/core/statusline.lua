local o = vim.o
local cmd = vim.cmd

local M = {}


M.highlight = function(group, fg, bg)
  cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

M.highlight("StatusLeft", "blue", "#32344a")
M.highlight("StatusMid", "green", "#32344a")
M.highlight("StatusRight", "yellow", "#32344a")


M.mode = function()
  return string.format(" [%s] ", string.upper(vim.api.nvim_get_mode().mode))
end

M.lsp = function()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError#⛔ " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning#⚠ " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint#⚐ " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation#ⓘ " .. count["info"]
  end

  -- return ## errors .. warnings .. hints .. info .. "%#Normal#"
  return errors .. warnings .. hints .. info
end

StatusLine = {}
StatusLine.show = function()
  return table.concat {
    -- "%#StatusLeft#",
    M.mode(), -- NeoVim mode
    "%f ", -- File Path
    "%m ",
    "%r ",
    M.lsp(),
    -- "%#StatusMid#",
    "%=",
    "%q",
    -- "%#StatusRight#",
    "%=",
    "%l,%c% :%L",
    "%5.5p%%",
    " %y ",
  }
end

o.statusline = "%!luaeval('StatusLine.show()')"
