local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_none()
  local f = fn.partialtrail(table.insert)
  local t = {}
  f(t, 1)
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 1)
end

function M.test_one()
  local t = {}
  local f = fn.partialtrail(table.insert, nil, 1)

  lu.assertEquals(#t, 0)
  f(t)
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 1)
end

function M.test_two()
  local t = {}
  local f = fn.partialtrail(table.insert, nil, t, 1)

  lu.assertEquals(#t, 0)
  f()
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 1)
end

function M.test_three()
  local t = {}
  local f = fn.partialtrail(table.insert, nil, t, 1, 3)

  lu.assertEquals(#t, 0)
  f()
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 3)
end

function M.test_reuse()
  local f = fn.partialtrail(math.max, 2, 5, 10)

  lu.assertErrorMsgContains('compare number with nil', function()
    f(1) -- passes nil as second value
  end)
  local got = f(1, 100)
  lu.assertEquals(got, 100)
  got = f(1, 100, 1000) -- 1000 is not passed
  lu.assertEquals(got, 100)
  got = f(1, 2, 3, 4)
  lu.assertEquals(got, 10)
end

function M.test_partial_partial()
  local f = fn.partialtrail(math.max, nil, 10, 20)
  local ff = fn.partialtrail(f, nil, 30, 40)

  local got = ff(1, 2)
  lu.assertEquals(got, 40)
  got = f(1, 2)
  lu.assertEquals(got, 20)
  got = ff(1, 2, 50)
  lu.assertEquals(got, 50)
  got = ff(1, 2, 30)
  lu.assertEquals(got, 40)
  got = f(1, 2, 30)
  lu.assertEquals(got, 30)
end

return M
