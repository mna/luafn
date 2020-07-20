local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_even()
  testing.forstats({count = 2, sum = 6},
    fn.filter(function(i) return i % 2 == 0 end, fn.fromto(1, 5)))
end

function M.test_none_match()
  testing.forstats({count = 0, sum = 0},
    fn.filter(function() return false end, fn.fromto(1, 5)))
end

function M.test_none_generated()
  testing.forstats({count = 0, sum = 0},
    fn.filter(function() return true end, fn.fromto(1, 0)))
end

function M.test_partial()
  local f = fn.filter(function(i) return i % 2 ~= 0 end)
  testing.forstats({count = 3, sum = 9},
    f(fn.fromto(1, 5)))
end

return M
