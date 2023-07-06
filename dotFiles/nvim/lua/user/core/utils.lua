-- Functions that are globly available

-- Prints a lua table content
function P(table)
  print(vim.inspect(table))
end

-- Reloads a module
function R(module)
  package.loaded[module] = nil
  return require(module)
end

-- TransparentColorScheme = false
-- Toggles Transparency for colorschemes
function TransparentColorSchemes(toggle)
  -- TransparentColorScheme = TransparentColorScheme == false and true or false
  -- print("Toggle flag: " .. toggle)
  R('catppuccin').setup({transparent_background = toggle})
  R('gruvbox').setup({transparent_mode = toggle})
  R('onedark').setup({transparent = toggle})
  -- R('kanagawa').setup({transparent = toggle})

  vim.cmd("colorscheme " .. vim.g.colors_name)
end
