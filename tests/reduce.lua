local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_sum()
  local got = fn.reduce(
    function(cumul, v) return cumul + v end,
    0,
    fn.fromto(1, 5))
  lu.assertEquals(got, 15)
end

function M.test_sub()
  local got = fn.reduce(
    function(cumul, v) return cumul - v end,
    0,
    fn.fromto(1, 5))
  lu.assertEquals(got, -15)
end

function M.test_collect()
  local got = fn.reduce(
    function(cumul, v)
      table.insert(cumul, v)
      return cumul
    end,
    {},
    fn.fromto(1, 5))
  lu.assertEquals(got, {1, 2, 3, 4, 5})
end

function M.test_none_generated()
  local got = fn.reduce(
    function(cumul, v) return cumul + v end,
    0,
    fn.fromto(5, 1))
  lu.assertEquals(got, 0)
end

function M.test_partial()
  local f = fn.reduce(function(cumul, v) return cumul + v end, 0)
  local got = f(fn.fromto(1, 4))
  lu.assertEquals(got, 10)
end

return M
