local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_empty()
	local got = fn.collectarray(nil, fn.fromto(5, 4))
	lu.assertEquals(got, {})
end

function M.test_simple()
	local got = fn.collectarray(nil, fn.fromto(1, 4))
	lu.assertEquals(got, {1, 2, 3, 4})
end

function M.test_mult_piped()
	local ar = {'a', 'b', 'c'}
	local pfn = fn.pipe(fn.collectarray({}))
	local got = pfn(ipairs(ar))
	lu.assertEquals(got, {1, 2, 3})
end

function M.test_append()
	local ar = {'a', 'b', 'c'}
	local pfn = fn.pipe(fn.collectarray({10, 20}))
	local got = pfn(ipairs(ar))
	lu.assertEquals(got, {10, 20, 1, 2, 3})
end

return M
