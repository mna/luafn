local testing = require 'tests.testing'
local fn = require 'fn'

local M = {}

function M.test_none()
  testing.forstats({count = 0, sum = 0},
    fn.concat())
end

function M.test_one()
  testing.forstats({count = 5, sum = 15},
    fn.concat({fn.fromto(1, 5)}))
end

function M.test_one_none_generated()
  testing.forstats({count = 0, sum = 0},
    fn.concat({fn.fromto(3, 1)}))
end

function M.test_two()
  testing.forstats({count = 8, sum = 48},
    fn.concat({fn.fromto(1, 5)}, {fn.fromto(10, 12)}))
end

function M.test_three()
  testing.forstats({count = 10, sum = 51},
    fn.concat({fn.fromto(1, 5)}, {fn.fromto(10, 12)}, {ipairs({'a', 'b'})}))
end

return M
