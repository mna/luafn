local lu = require 'luaunit'
local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_id()
  local pp = fn.pipe(function(...) return ... end)
  local v1, v2, v3 = pp(1, 'a', true)
  lu.assertEquals(v1, 1)
  lu.assertEquals(v2, 'a')
  lu.assertEquals(v3, true)
end

function M.test_filter_reduce()
  local pp = fn.pipe(
    fn.filter(function(v) return v % 2 == 0 end),
    fn.reduce(function(cumul, v) return cumul + v end, 0)
  )
  local got = pp(fn.fromto(1, 5))
  lu.assertEquals(got, 6)
end

function M.test_none()
  local pp = fn.pipe()
  -- no function in the pipe acts as an id
  local v1, v2, v3 = pp(1, 'a', true)
  lu.assertEquals(v1, 1)
  lu.assertEquals(v2, 'a')
  lu.assertEquals(v3, true)
end

function M.test_complex()
  local pp = fn.pipe(
    fn.filter(function(v) return v % 2 == 0 end), -- even numbers
    fn.skipwhile(function(v) return v < 100 end), -- over 100
    fn.taken(10), -- 100, 102, ..., 116, 118
    fn.map(function(v) return v * 2 end), -- 200, 204, ..., 232, 236
    fn.filter(function(v) return v % 10 == 0 end) -- 200, 220
  )
  testing.forstats({count = 2, sum = 420},
    pp(fn.fromto(1, math.huge)))
end

return M
