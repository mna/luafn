local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_empty()
	local got = fn.collectarray({}, fn.select(2, fn.fromto(5, 4)))
	lu.assertEquals(got, {})
end

function M.test_single_select_outbounds()
	local got = fn.collectarray({}, fn.select(2, fn.fromto(1, 4)))
	lu.assertEquals(got, {})
end

function M.test_select_one()
	local s = "from=world, to=Lua, last=val"

	local want = {'world', 'Lua', 'val'}
	local got = fn.collectarray({}, fn.select(3, string.gmatch(s, "(%w+)(=)(%w+)")))
	lu.assertEquals(got, want)
end

function M.test_select_negative()
	local s = "from=world, to=Lua, last=val"

	local want = {'=', '=', '='}
	local got = fn.collectarray({}, fn.select(-2, string.gmatch(s, "(%w+)(=)(%w+)")))
	lu.assertEquals(got, want)
end

function M.test_select_many()
	local s = "from=world, to=Lua, last=val"

	local want = {{'from', 'world', n=2}, {'to', 'Lua', n=2}, {'last', 'val', n=2}}
	local got = fn.collectarray({}, fn.pack(fn.select({1, 3}, string.gmatch(s, "(%w+)(=)(%w+)"))))
	lu.assertEquals(got, want)
end

function M.test_select_function()
	local s = "from=world, to=Lua, last=val"

	local want = {'morf', 'ot', 'tsal'}
	local got = fn.collectarray({}, fn.select(function(v)
		return string.reverse(v)
	end, string.gmatch(s, "(%w+)(=)(%w+)")))
	lu.assertEquals(got, want)
end

return M
