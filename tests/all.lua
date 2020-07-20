local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_none()
  local got, ix, v = fn.all(function() return false end, fn.fromto(1, 5))
  lu.assertFalse(got)
  lu.assertEquals(ix, 1)
  lu.assertEquals(v, 1)
end

function M.test_none_generated()
  local got, x = fn.all(function() return true end, fn.fromto(3, 1))
  lu.assertTrue(got)
  lu.assertNil(x)
end

function M.test_all()
  local got, x = fn.all(function() return true end, fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertNil(x)
end

function M.test_first()
  local got, ix, v = fn.all(function(v) return v ~= 1 end, fn.fromto(1, 5))
  lu.assertFalse(got)
  lu.assertEquals(ix, 1)
  lu.assertEquals(v, 1)
end

function M.test_second()
  local got, ix, v1, v2 = fn.all(function(pos) return pos < 2 end, utf8.codes('💩🐱🌝'))
  lu.assertFalse(got)
  lu.assertEquals(ix, 2)
  lu.assertEquals(v1, 5) -- pile of poo is 4 bytes
  lu.assertEquals(v2, 128049) -- cat face = 128049
end

function M.test_last()
  local got, ix, v1, v2 = fn.all(function(v) return v < 9 end, utf8.codes('💩🐱🌝'))
  lu.assertFalse(got)
  lu.assertEquals(ix, 3)
  lu.assertEquals(v1, 9) -- poo and cat are 4 bytes each
  lu.assertEquals(v2, 127773) -- full moon with face = 127773
end

function M.test_partial()
  local f = fn.all(function() return true end)
  local got, x = f(fn.fromto(1, 5))
  lu.assertTrue(got)
  lu.assertNil(x)
end

return M
