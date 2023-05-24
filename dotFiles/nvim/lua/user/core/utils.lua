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
