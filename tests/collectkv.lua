local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_empty()
	local got = fn.collectkv(nil, fn.fromto(5, 4))
	lu.assertEquals(got, {})
end

function M.test_simple_noval()
	local got = fn.collectkv(nil, fn.fromto(1, 4))
	lu.assertEquals(got, {})
end

function M.test_simple()
	local t = {x=1, y=2, z=3}
	local got = fn.collectkv(nil, pairs(t))
	lu.assertEquals(got, {x=1, y=2, z=3})
end

function M.test_many()
	local s = "from=world, to=Lua, last=val"
	local want = {from = '=', to = '=', last = '='}
	local got = fn.collectkv({}, string.gmatch(s, "(%w+)(=)(%w+)"))
	lu.assertEquals(got, want)
end

function M.test_pipe_append()
	local s = "from=world, to=Lua, last=val"
	local t = {other = 1}
	local pfn = fn.pipe(fn.select({3, 1}), fn.collectkv(t))
	local got = pfn(string.gmatch(s, "(%w+)(=)(%w+)"))

	local want = {world = 'from', Lua = 'to', val = 'last', other = 1}
	lu.assertEquals(got, want)
end

return M
