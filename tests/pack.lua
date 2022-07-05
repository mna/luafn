local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_empty()
	local got = fn.collectarray({}, fn.pack(fn.fromto(5, 4)))
	lu.assertEquals(got, {})
end

function M.test_simple()
	local got = fn.collectarray({}, fn.pack(fn.fromto(1, 4)))
	lu.assertEquals(got, {{1, n=1}, {2, n=1}, {3, n=1}, {4, n=1}})
end

function M.test_many()
	local ar = {1, 2}
	local got = fn.collectarray({}, fn.pack(ipairs(ar)))
	lu.assertEquals(got, {{1, 1, n=2}, {2, 2, n=2}})
end

return M
