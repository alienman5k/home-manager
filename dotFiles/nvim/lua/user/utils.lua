-- Functions that are globly available

-- Prints a lua table content
P = function(table)
  print(vim.inspect(table))
end

-- Reloads a module
R = function (module)
  package.loaded[module] = nil
  require"rest-client"
end
