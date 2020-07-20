local bm = require './benchmark'
local reporter = bm.bm(12)

-- Conclusion: it's basically the same time using table.pack
-- for each iteration vs reusing the same table with select.
-- Given this, the code is cleaner and simpler with table.pack.

local function fromto(from, to)
  return function(last, cur)
    from = cur + 1
    if from > last then return nil end
    return from, 'plus', 'other', 'data'
  end, to, from - 1
end

local function filter_table(p, it, inv, ctl)
  return function()
    while true do
      local res = table.pack(it(inv, ctl))
      ctl = res[1]
      if ctl == nil then return nil end

      if p(table.unpack(res, 1, res.n)) then
        return table.unpack(res, 1, res.n)
      end
    end
  end
end

local function filter_select(p, it, inv, ctl)
  -- reuses the same table for all iterations
  local results = {}
  local process = function(...)
    results.n = select('#', ...)
    for i = 1, results.n do
      results[i] = select(i, ...)
    end
  end
  return function()
    while true do
      process(it(inv, ctl))
      ctl = results[1]
      if ctl == nil then return nil end

      if p(table.unpack(results, 1, results.n)) then
        return table.unpack(results, 1, results.n)
      end
    end
  end
end

local outern, innern = 1000, 10000

reporter:report(function()
  for _ = 1, outern do
    local count = 0
    for _ in filter_select(function(...) return true end, fromto(1, innern)) do
      count = count + 1
    end
    assert(count == innern)
  end
end, 'select')

reporter:report(function()
  for _ = 1, outern do
    local count = 0
    for _ in filter_table(function(...) return true end, fromto(1, innern)) do
      count = count + 1
    end
    assert(count == innern)
  end
end, 'table')

