local lu = require 'luaunit'

local M = {}

function M.forstats(t, ...)
  local sum, count = 0, 0
  for i in ... do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, t.count)
  lu.assertEquals(sum, t.sum)
end

return M
