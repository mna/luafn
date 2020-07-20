local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_1_5()
  testing.forstats({count = 5, sum = 15},
    fn.fromto(1, 5))
end

function M.test_2_2()
  testing.forstats({count = 1, sum = 2},
    fn.fromto(2, 2))
end

function M.test_4_1()
  testing.forstats({count = 0, sum = 0},
    fn.fromto(4, 1))
end

function M.test_m3_3()
  testing.forstats({count = 7, sum = 0},
    fn.fromto(-3, 3))
end

return M
