local function printGridHex(grid)
  local w = io.write
  for i,row in ipairs(grid) do
    for i,cell in ipairs(row) do
      w(string.format('%x ', cell))
    end
    print('')
  end
end

return printGridHex
