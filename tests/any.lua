local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_none()
  local got, x = fn.any(function() return false end, fn.fromto(1, 5))
  lu.assertFalse(got)
  lu.assertNil(x)
end

function M.test_none_generated()
  local got, x = fn.any(function() return true end, fn.fromto(3, 1))
  lu.assertFalse(got)
  lu.assertNil(x)
end

function M.test_all()
  local got, ix, v = fn.any(function() return true end, fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertEquals(ix, 1)
  lu.assertEquals(v, 1)
end

function M.test_first()
  local got, ix, v = fn.any(function(v) return v == 1 end, fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertEquals(ix, 1)
  lu.assertEquals(v, 1)
end

function M.test_second()
  local got, ix, v = fn.any(function(v) return v == 2 end, fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertEquals(ix, 2)
  lu.assertEquals(v, 2)
end

function M.test_last()
  local got, ix, v = fn.any(function(v) return v == 5 end, fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertEquals(ix, 5)
  lu.assertEquals(v, 5)
end

function M.test_partial()
  local f = fn.any(function() return true end)
  local got, ix, v = f(fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertEquals(ix, 1)
  lu.assertEquals(v, 1)
end

return M
