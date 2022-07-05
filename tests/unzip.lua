local testing = require 'tests.testing'
local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_empty()
  testing.forstats({count = 0, sum = 0},
    fn.unzip(fn.fromto(5, 4)))
end

function M.test_simple()
  testing.forstats({count = 4, sum = 10},
    fn.unzip(fn.fromto(1, 4)))
end

function M.test_dual()
	local want = {1, 'a', 2, 'b', 3, 'c'}
	local got = fn.collectarray({}, fn.unzip(ipairs({'a', 'b', 'c'})))
	lu.assertEquals(got, want)
end

function M.test_multiple()
	local s = "from=world, to=Lua, last=val"

	local want = {'from', '=', 'world', 'to', '=', 'Lua', 'last', '=', 'val'}
	local got = fn.collectarray({}, fn.unzip(string.gmatch(s, "(%w+)(=)(%w+)")))
	lu.assertEquals(got, want)
end

return M
