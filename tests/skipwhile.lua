local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_always()
  testing.forstats({count = 0, sum = 0},
    fn.skipwhile(function() return true end, fn.fromto(1, 5)))
end

function M.test_never()
  testing.forstats({count = 5, sum = 15},
    fn.skipwhile(function() return false end, fn.fromto(1, 5)))
end

function M.test_some()
  testing.forstats({count = 4, sum = 14},
    fn.skipwhile(function(v) return v < 2 end, fn.fromto(1, 5)))
end

function M.test_partial()
  local f = fn.skipwhile(function(v) return v < 3 end)
  testing.forstats({count = 3, sum = 12},
    f(fn.fromto(1, 5)))
end

return M
