local testing = require 'tests.testing'
local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_none()
  testing.forstats({count = 0, sum = 0},
    fn.zip())
end

function M.test_empty()
  testing.forstats({count = 0, sum = 0},
    fn.zip({fn.fromto(5, 4)}))
end

function M.test_single()
  testing.forstats({count = 4, sum = 10},
    fn.zip({fn.fromto(1, 4)}))
end

function M.test_dual()
	local want = {{1, 10, n=2}, {2, 11, n=2}, {3, 12, n=2}, {4, 13, n=2}}
  local pipefn = fn.pipe(
		fn.zip,
		fn.pack,
		fn.collectarray({})
	)
	local got = pipefn({fn.fromto(1, 4)}, {fn.fromto(10, 20)})
	lu.assertEquals(got, want)
end

function M.test_multiple()
	local want = {{1, 10, 100, n=3}, {2, nil, 101, n=3}, {3, nil, nil, n=3}}
  local pipefn = fn.pipe(
		fn.zip,
		fn.pack,
		fn.collectarray({})
	)
	local got = pipefn({fn.fromto(1, 3)}, {fn.fromto(10, 10)}, {fn.fromto(100, 101)})
	lu.assertEquals(got, want)
end

return M

