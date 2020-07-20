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
    local all = {table.unpack(args, 1, args.n)}
    local count = select('#', ...)
    for i = 1, count do
      table.insert(all, (select(i, ...)))
    end
    all.n = args.n + count
    return f(table.unpack(all, 1, all.n))
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
    cumul = f(cumul, table.unpack(res, 1, res.n))
  end
end

-- Take the first n results of iterator it.
-- Return a new iterator that takes at most those first n results.
-- If it is nil, returns a partially-applied function with the n
-- value set.
function M.taken(n, it, inv, ctl)
  if it == nil then return M.partial(M.taken, n) end

  return function()
    if n <= 0 then return nil end

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

-- Any calls predicate p with all values of each iteration of it and
-- returns true as soon as p returns true, along with the index of the
-- iteration that returned true and all its values.
-- It returns false as the only value if the iteration is completed
-- without p returning true.
-- If it is nil, returns a partially-applied function with the predicate
-- p set.
function M.any(p, it, inv, ctl)
  if it == nil then return M.partial(M.any, p) end

  local ix = 0
  while true do
    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return false end
    ix = ix + 1

    if p(table.unpack(res, 1, res.n)) then
      return true, ix, table.unpack(res, 1, res.n)
    end
  end
end

-- All calls predicate p with all values of each iteration of it and
-- returns false as soon as p returns false, along with the index of the
-- iteration that returned false and all its values.
-- It returns true as the only value if the iteration is completed without
-- p returning false.
-- If it is nil, returns a partially-applied function with the predicate
-- p set.
function M.all(p, it, inv, ctl)
  if it == nil then return M.partial(M.all, p) end

  local ix = 0
  while true do
    local res = table.pack(it(inv, ctl))
    ctl = res[1]
    if ctl == nil then return true end
    ix = ix + 1

    if not p(table.unpack(res, 1, res.n)) then
      return false, ix, table.unpack(res, 1, res.n)
    end
  end
end

-- Concat concatenates the provided iterators together, returning
-- a new iterator that loops through all iterators in a single
-- sequence. The arguments must be provided as a list of tables,
-- each table an array containing the iterator tuple (i.e. the
-- iterator function, its invariant value and its control value).
-- A common way to generate this is e.g.:
--   fn.concat({pairs(t1)}, {pairs(t2)})
-- Another option is with table.pack (the 'n' field is used if
-- it is set):
--   fn.concat(table.pack(pairs(t1)), table.pack(pairs(t2)))
function M.concat(...)
  local ix = 1
  local its = table.pack(...)

  return function()
    while true do
      local t = its[ix]
      if t == nil then return nil end

      local it, inv, ctl = t[1], t[2], t[3]
      local res = table.pack(it(inv, ctl))
      t[3] = res[1]

      if t[3] == nil then
        ix = ix + 1
      else
        return table.unpack(res, 1, res.n)
      end
    end
  end
end

-- Callmethod calls the method m on table t, passing the args
-- an any additional arguments received after t. The args
-- parameter is treated as a "packed" table, it is unpacked when
-- t.m is called, and the rest of the arguments (after t) are
-- passed after the unpacked args. This is so that callmethod
-- can be partially applied with some arguments before receiving
-- the table instance on which to call the method.
-- If t is nil, returns a partially-applied function with the
-- method name m and (if non-nil) the args table set. Pass an empty
-- table (and not nil) as args if there are no arguments to provide.
function M.callmethod(m, args, t, ...)
  if t == nil then
    if args == nil then return M.partial(M.callmethod, m) end
    return M.partial(M.callmethod, m, args)
  end

  local all = {table.unpack(args, 1, args.n)}
  local count = select('#', ...)
  for i = 1, count do
    table.insert(all, (select(i, ...)))
  end
  all.n = (args.n or #args) + count
  return t[m](t, table.unpack(all, 1, all.n))
end

return M
