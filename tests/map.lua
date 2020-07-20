local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_negate()
  testing.forstats({count = 5, sum = -15},
    fn.map(function(v) return -v end, fn.fromto(1, 5)))
end

function M.test_none_generated()
  testing.forstats({count = 0, sum = 0},
    fn.map(function(v) return -v end, fn.fromto(1, 0)))
end

function M.test_partial()
  local f = fn.map(function(i) return -i end)
  testing.forstats({count = 5, sum = -15},
    f(fn.fromto(1, 5)))
end

return M
