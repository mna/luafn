local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_less()
  testing.forstats({count = 3, sum = 6},
    fn.taken(3, fn.fromto(1, 5)))
end

function M.test_more()
  testing.forstats({count = 2, sum = 3},
    fn.taken(3, fn.fromto(1, 2)))
end

function M.test_none()
  testing.forstats({count = 0, sum = 0},
    fn.taken(0, fn.fromto(1, 5)))
end

function M.test_neg()
  testing.forstats({count = 0, sum = 0},
    fn.taken(-2, fn.fromto(1, 5)))
end

function M.test_none_generated()
  testing.forstats({count = 0, sum = 0},
    fn.taken(2, fn.fromto(5, 1)))
end

function M.test_partial()
  local f = fn.taken(3)
  testing.forstats({count = 3, sum = 33},
    f(fn.fromto(10, 20)))
end

return M
