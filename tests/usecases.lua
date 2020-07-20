local lu = require 'luaunit'
local fn = require 'fn'

local M = {}

function M.test_contains()
  -- implement 'contains' by using 'any'
  local got, ix, v = fn.any(function(c) return c == 'x' end, string.gmatch('abcxd', '.'))
  lu.assertTrue(got)
  lu.assertEquals(ix, 4)
  lu.assertEquals(v, 'x')
end

function M.test_first()
  -- implement 'first' by using 'any'
  local got, ix, v = fn.any(function(c) return c == 'x' end, string.gmatch('abcxdefxg', '.'))
  lu.assertTrue(got)
  lu.assertEquals(ix, 4)
  lu.assertEquals(v, 'x')
end

function M.test_act_on_first()
  -- act on 'first' by using a pipe with 'any' and 'select'
  local pp = fn.pipe(fn.any(function(c) return c == 'x' end), fn.partial(select, 3), string.upper)
  local got = pp(string.gmatch('abcxdefxg', '.'))
  lu.assertEquals(got, 'X')
end

function M.test_min()
  -- implement 'min' by using 'reduce'
  local vs = {12, 34, 2, 5, 44}
  local got = fn.reduce(function(cumul, _, v)
    if v < cumul then
      return v
    else
      return cumul
    end
  end, math.maxinteger, ipairs(vs))
  lu.assertEquals(got, 2)
end

function M.test_max()
  -- implement 'max' by using 'reduce'
  local vs = {12, 34, 2, 5, 44, 10}
  local got = fn.reduce(function(cumul, _, v)
    if v > cumul then
      return v
    else
      return cumul
    end
  end, math.mininteger, ipairs(vs))
  lu.assertEquals(got, 44)
end

function M.test_collect_array()
  -- implement collecting an iterator in an array by using 'reduce'
  local got = fn.reduce(function(t, v)
    -- sadly, cannot use simply table.insert as it returns nothing
    table.insert(t, v)
    return t
  end, {}, fn.fromto(1, 10))
  lu.assertEquals(got, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
end

function M.test_collect_dict()
  -- implement collecting an iterator in a dictionary by using 'reduce'
  local src = {a = 1, b = 2, c = 3}
  local got = fn.reduce(function(t, k, v)
    t[k] = v
    return t
  end, {}, pairs(src))
  lu.assertEquals(got, src)
end

function M.test_reorder_values()
  -- implement reordering values from an iterator by using 'map'
  local src = {a = 1, b = 2, c = 3}
  local dst = {}
  for k, v in fn.map(function(k, v) return v, k end, pairs(src)) do
    dst[k] = v
  end
  lu.assertEquals(dst, {[1] = 'a', [2] = 'b', [3] = 'c'})
end

function M.test_create_set_from_array()
  -- implement creating a set from an array by using 'reduce'
  local src = {'a', 'b', 'c', 'a', 'd'}
  local got = fn.reduce(function(cumul, _, v)
    cumul[v] = true
    return cumul
  end, {}, ipairs(src))
  lu.assertEquals(got, {a = true, b = true, c = true, d = true})
end

return M
