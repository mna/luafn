local M = {}

-- Return an iterator that generates all integers starting at from
-- and ending at to, inclusive.
function M.fromto(from, to)
  return function(last, cur)
    from = cur + 1
    if from > last then return nil end
    return from
  end, to, from - 1
end

-- Partial binds the provided arguments to function f and returns a new
-- function that, when called, executes with the combination of the
-- partially-applied arguments and newly provided arguments.
function M.partial(f, ...)
  local args = table.pack(...)
  return function(...)
    return f(table.unpack(args, 1, args.n), ...)
  end
end

-- Pipe returned values to the input arguments of the next function,
-- in left-to-right composition.
-- Return a function that applies the pipe.
function M.pipe(...)
  local fns = table.pack(...)
  return function(...)
    local args = table.pack(...)
    for i = 1, fns.n do
      args = table.pack(fns[i](table.unpack(args, 1, args.n)))
    end
    return table.unpack(args, 1, args.n)
  end
end

-- Filter iterator it by keeping only items that satisfy predicate p.
-- Return a new iterator that applies the filter.
-- If it is nil, returns a partially-applied function with the predicate
-- set.
function M.filter(p, it, inv, ctl)
  if it == nil then return M.partial(M.filter, p) end

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

-- Map iterator it by calling f on each iteration and returning its
-- returned values instead of the original ones. Note that returning
-- nil from f as first value end the iterator.
-- Return a new iterator that applies the map.
-- If it is nil, returns a partially-applied function with the map
-- function set.
function M.map(f, it, inv, ctl)
  if it == nil then return M.partial(M.map, f) end

  return function()
    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return nil end

    return f(table.unpack(res, 1, res.n))
  end
end

-- Reduce iterator it by calling fn on each iteration with the
-- accumulator cumul and all values returned for this iteration.
-- Return the final value of the accumulator.
-- If it is nil, returns a partially-applied function with the
-- reduce function and, if provided, the accumulator value.
function M.reduce(f, cumul, it, inv, ctl)
  if it == nil then
    if cumul == nil then return M.partial(M.reduce, f) end
    return M.partial(M.reduce, f, cumul)
  end

  while true do
    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return cumul end
    f(cumul, table.unpack(res, 1, res.n))
  end
end

-- Take the first n results of iterator it.
-- Return a new iterator that takes at most those first n results.
-- If it is nil, returns a partially-applied function with the n
-- value set.
function M.taken(n, it, inv, ctl)
  if it == nil then return M.partial(M.taken, n) end

  return function()
    if n == 0 then return nil end

    n = n - 1
    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return nil end
    return table.unpack(res, 1, res.n)
  end
end

-- Take the iterator's it results while the predicate p returns true.
-- The predicate is called with the values of each iteration.
-- Return a new iterator that applies the take while condition.
-- If it is nil, returns a partially-applied function with the predicate
-- p set.
function M.takewhile(p, it, inv, ctl)
  if it == nil then return M.partial(M.takewhile, p) end

  local stop = false
  return function()
    if stop then return nil end

    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return nil end

    if p(table.unpack(res, 1, res.n)) then
      return table.unpack(res, 1, res.n)
    end
    stop = true
  end
end

-- Skip the first n results of iterator it.
-- Return a new iterator that skips those first n results.
-- If it is nil, returns a partially-applied function with the n
-- value set.
function M.skipn(n, it, inv, ctl)
  if it == nil then return M.partial(M.skipn, n) end

  return function()
    while n > 0 do
      ctl = it(inv, ctl)
      n = n - 1
      if ctl == nil then return nil end
    end
    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return nil end
    return table.unpack(res, 1, res.n)
  end
end

-- Skip the iterator's it results while the predicate p returns true.
-- The predicate is called with the values of each iteration.
-- Return a new iterator that applies the skip while condition.
-- If it is nil, returns a partially-applied function with the predicate
-- p set.
function M.skipwhile(p, it, inv, ctl)
  if it == nil then return M.partial(M.skipwhile, p) end

  local skipping = true
  return function()
    while skipping do
      local res = table.pack(it(inv, ctl))
      ctl = res[1]
      if ctl == nil then return nil end
      if not p(table.unpack(res, 1, res.n)) then
        skipping = false
        return table.unpack(res, 1, res.n)
      end
    end

    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return nil end
    return table.unpack(res, 1, res.n)
  end
end

return M
