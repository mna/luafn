local lu = require 'luaunit'
local fn = require 'fn'

TestFromTo = {}
function TestFromTo.test_1_5()
  local sum, count = 0, 0
  for i in fn.fromto(1, 5) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 5)
  lu.assertEquals(sum, 15)
end

function TestFromTo.test_2_2()
  local sum, count = 0, 0
  for i in fn.fromto(2, 2) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 1)
  lu.assertEquals(sum, 2)
end

function TestFromTo.test_4_1()
  local sum, count = 0, 0
  for i in fn.fromto(4, 1) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 0)
  lu.assertEquals(sum, 0)
end

function TestFromTo.test_m3_3()
  local sum, count = 0, 0
  for i in fn.fromto(-3, 3) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 7)
  lu.assertEquals(sum, 0)
end

TestFilter = {}
function TestFilter.test_even()
  local sum, count = 0, 0
  for i in fn.filter(function(i) return i % 2 == 0 end, fn.fromto(1, 5)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 2)
  lu.assertEquals(sum, 6)
end

function TestFilter.test_none_match()
  local sum, count = 0, 0
  for i in fn.filter(function() return false end, fn.fromto(1, 5)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 0)
  lu.assertEquals(sum, 0)
end

function TestFilter.test_none_generated()
  local sum, count = 0, 0
  for i in fn.filter(function() return true end, fn.fromto(1, 0)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 0)
  lu.assertEquals(sum, 0)
end

function TestFilter.test_partial()
  local sum, count = 0, 0
  local f = fn.filter(function(i) return i % 2 ~= 0 end)
  for i in f(fn.fromto(1, 5)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 3)
  lu.assertEquals(sum, 9)
end

TestMap = {}
function TestMap.test_negate()
  local sum, count = 0, 0
  for i in fn.map(function(v) return -v end, fn.fromto(1, 5)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 5)
  lu.assertEquals(sum, -15)
end

function TestMap.test_none_generated()
  local sum, count = 0, 0
  for i in fn.map(function(v) return -v end, fn.fromto(1, 0)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 0)
  lu.assertEquals(sum, 0)
end

function TestMap.test_partial()
  local sum, count = 0, 0
  local f = fn.map(function(i) return -i end)
  for i in f(fn.fromto(1, 5)) do
    count = count + 1
    sum = sum + i
  end
  lu.assertEquals(count, 5)
  lu.assertEquals(sum, -15)
end

os.exit(lu.LuaUnit.run())
