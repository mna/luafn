local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_less()
  testing.forstats({count = 2, sum = 9},
    fn.skipn(3, fn.fromto(1, 5)))
end

function M.test_more()
  testing.forstats({count = 0, sum = 0},
    fn.skipn(3, fn.fromto(1, 2)))
end

function M.test_none()
  testing.forstats({count = 5, sum = 15},
    fn.skipn(0, fn.fromto(1, 5)))
end

function M.test_neg()
  testing.forstats({count = 5, sum = 15},
    fn.skipn(-2, fn.fromto(1, 5)))
end

function M.test_none_generated()
  testing.forstats({count = 0, sum = 0},
    fn.skipn(2, fn.fromto(5, 1)))
end

function M.test_partial()
  local f = fn.skipn(3)
  testing.forstats({count = 3, sum = 42},
    f(fn.fromto(10, 15)))
end

return M
