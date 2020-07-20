local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_none()
  local f = fn.partial(table.insert)
  local t = {}
  f(t, 1)
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 1)
end

function M.test_one()
  local t = {}
  local f = fn.partial(table.insert, t)

  lu.assertEquals(#t, 0)
  f(2)
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 2)
end

function M.test_two()
  local t = {}
  local f = fn.partial(table.insert, t, 1)

  lu.assertEquals(#t, 0)
  f(2)
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 2)
end

function M.test_three()
  local t = {}
  local f = fn.partial(table.insert, t, 1, 3)

  lu.assertEquals(#t, 0)
  f()
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 3)
end

function M.test_reuse()
  local t = {}
  local f = fn.partial(table.insert, t)

  lu.assertEquals(#t, 0)
  f(1)
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 1)
  f(2)
  lu.assertEquals(#t, 2)
  lu.assertEquals(t[1], 1)
  lu.assertEquals(t[2], 2)
  f(3)
  lu.assertEquals(#t, 3)
  lu.assertEquals(t[1], 1)
  lu.assertEquals(t[2], 2)
  lu.assertEquals(t[3], 3)
end

function M.test_partial_partial()
  local t = {}
  local f = fn.partial(table.insert, t)
  local ff = fn.partial(f, 1)

  lu.assertEquals(#t, 0)
  ff('a')
  lu.assertEquals(#t, 1)
  lu.assertEquals(t[1], 'a')
  ff('b')
  lu.assertEquals(#t, 2)
  lu.assertEquals(t[1], 'b')
  lu.assertEquals(t[2], 'a')
  ff('c')
  lu.assertEquals(#t, 3)
  lu.assertEquals(t[1], 'c')
  lu.assertEquals(t[2], 'b')
  lu.assertEquals(t[3], 'a')
end

return M
