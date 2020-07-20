local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_always()
  testing.forstats({count = 5, sum = 15},
    fn.takewhile(function() return true end, fn.fromto(1, 5)))
end

function M.test_never()
  testing.forstats({count = 0, sum = 0},
    fn.takewhile(function() return false end, fn.fromto(1, 5)))
end

function M.test_some()
  testing.forstats({count = 1, sum = 1},
    fn.takewhile(function(v) return v < 2 end, fn.fromto(1, 5)))
end

function M.test_partial()
  local f = fn.takewhile(function(v) return v < 3 end)
  testing.forstats({count = 2, sum = 3},
    f(fn.fromto(1, 5)))
end

return M
