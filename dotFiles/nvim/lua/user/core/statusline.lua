local M = {}

local sl_clear = '%#hi clear group#'
-- function M.set_hl(name, val, base)
--   -- Check if buffer is current or not
--   -- Get the existing StatusLine/StatusLineNC Highlight values
--   if base then
--     -- Use base and override
--     print("use base")
--   end
--   vim.api.nvim_set_hl(0, name, val)
-- end

function M.create_highlights()
  local sl = vim.api.nvim_get_hl(0, {name="StatusLine"})
  local sl_bg = sl.reverse and sl.fg or sl.bg

  local sl_mode = vim.api.nvim_get_hl(0, {name='character', link=false})
  sl_mode.bg = sl_bg
  vim.api.nvim_set_hl(0, 'SLMode', sl_mode)
  vim.api.nvim_set_hl(0, 'SLModeNC', {link='StatusLineNC'})

  local sl_file = {
    fg = vim.api.nvim_get_hl(0, {name='Title', link=false}).fg,
    bg = sl.reverse and sl.fg or sl.bg
  }
  vim.api.nvim_set_hl(0, 'SLFile', sl_file)
  vim.api.nvim_set_hl(0, 'SLFileNC', {link='StatusLineNC'})

  local diag_error = vim.api.nvim_get_hl(0, {name="DiagnosticError"})
  local sl_diag_error = {
    bg = sl.reverse and sl.fg or sl.bg,
    fg = diag_error.fg
  }
  vim.api.nvim_set_hl(0, 'SLDiagnosticError', sl_diag_error)

  local diag_warn = vim.api.nvim_get_hl(0, {name="DiagnosticWarn"})
  local sl_diag_warn = {
    bg = sl.reverse and sl.fg or sl.bg,
    fg = diag_warn.fg
  }
  vim.api.nvim_set_hl(0, 'SLDiagnosticWarn', sl_diag_warn)

  local diag_info = vim.api.nvim_get_hl(0, {name="DiagnosticInfo"})
  local sl_diag_info = {
    bg = sl.reverse and sl.fg or sl.bg,
    fg = diag_info.fg
  }
  vim.api.nvim_set_hl(0, 'SLDiagnosticInfo', sl_diag_info)

  local diag_hint = vim.api.nvim_get_hl(0, {name="DiagnosticHint"})
  local sl_diag_hint = {
    bg = sl.reverse and sl.fg or sl.bg,
    fg = diag_hint.fg
  }
  vim.api.nvim_set_hl(0, 'SLDiagnosticHint', sl_diag_hint)

end

M.create_highlights()

function M.mode(current)
  -- return string.format(" [%s] ", string.upper(vim.api.nvim_get_mode().mode))
  local sl_mode = current and '%#SLMode#' or '%#SLModeNC#'
  local mode = string.format("%s[%s]%s", sl_mode, string.upper(vim.api.nvim_get_mode().mode), sl_clear)
  -- local mode = string.format(" [%s] ", string.upper(vim.api.nvim_get_mode().mode))
  return mode
end

function M.file(active)
  -- local file = "%#SLFile# %y %t " .. sl_clear
  local hl_slfile = active and '%#SLFile#' or '%#SLFileNC#'
  local file = hl_slfile .. ' %t ' .. sl_clear
  -- local file = " %t "
  return file
end

function M.lsp(active)
  -- if not active or not vim.diagnostic.is_disabled(0) then
  if not active then
    -- print(string.format('Active LSP: %s, %s', active, vim.diagnostic.is_disabled(0)))
    return ""
  end

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
    errors = string.format("%s%sE ", '%#SLDiagnosticError#', count["errors"])
  end
  if count["warnings"] ~= 0 then
    warnings = string.format("%s%sW ", '%#SLDiagnosticWarn#', count["warnings"])
  end
  if count["hints"] ~= 0 then
    hints = string.format("%s%sH ", '%#SLDiagnosticHint#', count["hints"])
  end
  if count["info"] ~= 0 then
    info = string.format("%s%sI ", '%#SLDiagnosticInfo#', count["info"])
  end

  return errors .. warnings .. hints .. info .. sl_clear
end

StatusLine = {
  show_status = function(active)
    return table.concat {
      -- Left
      M.mode(active), -- NeoVim mode
      -- "%#AlphaHeader#",
      M.file(active),
      -- "%10.50f ",    -- File Path
      "%m ",
      "%r ",
      M.lsp(active),
      -- M.lsp(),
      -- Middle
      "%=",
      "%q",
      -- Right
      "%=",
      -- "%l|%c : %L ",
      -- "%l/%L | %c",
      -- "%l,%c% :%L",
      "ln: %l/%L  col: %c",
      "%5.5p%%",
      " %y ",
    }
  end
}

function M.status_active()
  vim.opt_local.statusline = "%!luaeval('StatusLine.show_status(true)')"
end

function M.status_inactive()
  vim.opt_local.statusline = "%!luaeval('StatusLine.show_status(false)')"
end


local slgroup = vim.api.nvim_create_augroup("StatusLineColorGroup", { clear = true })
vim.api.nvim_create_autocmd({"ColorScheme"}, {
  group = slgroup,
  callback = M.create_highlights,
})
vim.api.nvim_create_autocmd({'WinLeave'}, {
  group = slgroup,
  pattern = '*',
  callback = M.status_inactive
})
vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter'}, {
  group = slgroup,
  pattern = '*',
  callback = M.status_active
})


vim.o.laststatus = 2 -- 2 Statsuline in each window. 3 Statusline only at the bottom
-- vim.o.statusline = "%!luaeval('StatusLine.show_status()')"
vim.o.winbar = "%=%#StatusLineNC#%f" .. sl_clear .. "%="
