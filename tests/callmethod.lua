local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_call_noarg()
  local s = 'allo'
  local got = fn.callmethod('upper', {}, s)
  lu.assertEquals(got, 'ALLO')
end

function M.test_call_prearg()
  local s = 'allo'
  local got = fn.callmethod('byte', {2}, s)
  lu.assertEquals(got, 108) -- 'l' == 108
end

function M.test_call_prearg2()
  local s = 'allo'
  local b1, b2 = fn.callmethod('byte', {3, 4}, s)
  lu.assertEquals(b1, 108) -- 'l' == 108
  lu.assertEquals(b2, 111) -- 'o' == 111
end

function M.test_call_postarg()
  local s = 'allo'
  local b = fn.callmethod('byte', {}, s, 2)
  lu.assertEquals(b, 108) -- 'l' == 108
end

function M.test_call_postarg2()
  local s = 'allo'
  local b1, b2 = fn.callmethod('byte', {}, s, 3, 4)
  lu.assertEquals(b1, 108) -- 'l' == 108
  lu.assertEquals(b2, 111) -- 'o' == 111
end

function M.test_call_prepostarg()
  local s = 'allo'
  local b1, b2 = fn.callmethod('byte', {3}, s, 4)
  lu.assertEquals(b1, 108) -- 'l' == 108
  lu.assertEquals(b2, 111) -- 'o' == 111
end

function M.test_partial()
  local f = fn.callmethod('byte', {3})
  local b = f('allo')
  lu.assertEquals(b, 108) -- 'l' == 108
end

return M
