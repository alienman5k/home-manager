local M = {}


function M.set_hl(name, val, base)
  -- Check if buffer is current or not
  -- Get the existing StatusLine/StatusLineNC Highlight values
  if base then
    -- Use base and override
    print("use base")
  end
  vim.api.nvim_set_hl(0, name, val)
end


function M.mode()
  return string.format(" [%s] ", string.upper(vim.api.nvim_get_mode().mode))
end

function M.lsp()
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
    -- errors = " %#LspDiagnosticsError#? " .. count["errors"]
    errors = " %#DiagnosticError# " .. count["errors"] .. "E"
  end
  if count["warnings"] ~= 0 then
    -- warnings = " %#LspDiagnosticsWarning#? " .. count["warnings"]
    warnings = "  %#DiagnosticWarn#" .. count["warnings"] .. "W"
  end
  if count["hints"] ~= 0 then
    -- hints = " %#LspDiagnosticsHint#? " .. count["hints"]
    hints = "  %#DiagnosticHint#" .. count["hints"] .. "H"
  end
  if count["info"] ~= 0 then
    -- info = " %#LspDiagnosticsInformation#? " .. count["info"]
    info = "  %#DiagnosticInfo#" .. count["info"] .. "I"
  end

  -- return ## errors .. warnings .. hints .. info .. "%#Normal#"
  return errors .. warnings .. hints .. info
end

StatusLine = {
  show_status = function()
    return table.concat {
      -- "%#StatusLeft#",
      -- "%#Character#",
      M.mode(), -- NeoVim mode
      -- "%#AlphaHeader#",
      "%t ",    -- File Path
      -- "%10.50f ",    -- File Path
      "%m ",
      "%r ",
      "%!" .. M.lsp(),
      -- "%#StatusMid#",
      -- "%#ColorColumn#",
      "%#hi clear group#",
      "%=",
      "%q",
      -- "%#StatusRight#",
      "%=",
      -- "%l|%c : %L ",
      -- "%l/%L | %c",
      "%l,%c% :%L",
      "%5.5p%%",
      -- "%#Keyword#",
      -- "%#@text.note#",
      -- "%#AlphaFooter#",
      " %y ",
    }
  end
}

vim.o.statusline = "%!luaeval('StatusLine.show_status()')"
