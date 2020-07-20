local lu = require 'luaunit'

local M = {}

function M.forstats(t, ...)
  local sum, count = 0, 0
  for i in ... do
    count = count + 1
    sum = sum + i
  end
  if t.count then lu.assertEquals(count, t.count) end
  if t.sum then lu.assertEquals(sum, t.sum) end
end

return M
