local fn = vim.fn
local o = vim.o
local cmd = vim.cmd

local function highlight(group, fg, bg)
  cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

highlight("StatusLeft", "blue", "#32344a")
highlight("StatusMid", "green", "#32344a")
highlight("StatusRight", "yellow", "#32344a")

-- local function get_column_number()
--     return fn.col(".")
-- end

local function mode()
  return string.format(" [%s] ", vim.api.nvim_get_mode().mode):upper()
end

local function lsp()
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
    errors = " %#LspDiagnosticsSignError# " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation# " .. count["info"]
  end

  -- return ## errors .. warnings .. hints .. info .. "%#Normal#"
  return errors .. warnings .. hints .. info
end


StatusLine = {}

function StatusLine.show()
  -- return table.concat {
  --     "%#StatusLeft#",
  --     "%f",
  --     "%=",
  --     "%#StatusMid#",
  --     "%l,",
  --     get_column_number(),
  --     "%=",
  --     "%#StatusRight#",
  --     "%p%%"
  -- }
  return table.concat {
    -- "%#StatusLeft#",
    mode(), -- NeoVim mode
    "%f ", -- File Path
    "%m ",
    "%r ",
    lsp(),
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
