# luafn

A pure Lua module with no external dependency that provides functional programming fundamentals such as map, filter, reduce and pipe. All core functions work with iterators and as such are lazily evaluated.

* Canonical repository: https://git.sr.ht/~mna/luafn
* Issue tracker: https://todo.sr.ht/~mna/luafn

## Install

Via Luarocks:

```
$ luarocks install luafn
```

Or simply copy the single fn.lua file in your project or your `LUA_PATH`.

## API

Assuming `local fn = require 'fn'`. You can check out the tests, and especially `tests/usecases.lua` for actual examples of using the API.

### `fn.fromto(from, to)`

Return an iterator that generates all integers starting at from
and ending at to, inclusive.

### `fn.partial(f, ...)`

Partial binds the provided arguments to function f and returns a new
function that, when called, executes with the combination of the
partially-applied arguments and newly provided arguments.

### `fn.partialtrail(f, exactly, ...)`

Same as partial, except that the partially-applied arguments are added
at the end of the newly provided arguments. If exactly is not nil, then
that exact number of newly provided arguments are passed before adding
the partially-applied ones, adding nil values in-between as required.

### `fn.pipe(...)`

Pipe returned values to the input arguments of the next function,
in left-to-right composition.
Return a function that applies the pipe.

### `fn.filter(p, it, inv, ctl)`

Filter iterator it by keeping only items that satisfy predicate p.
Return a new iterator that applies the filter.
If "it" is nil, returns a partially-applied function with the predicate
set.

### `fn.map(f, it, inv, ctl)`

Map iterator it by calling f on each iteration and returning its
returned values instead of the original ones. Note that returning
nil from f as first value end the iterator.
Return a new iterator that applies the map.
If "it" is nil, returns a partially-applied function with the map
function set.

### `fn.reduce(f, cumul, it, inv, ctl)`

Reduce iterator it by calling fn on each iteration with the
accumulator cumul and all values returned for this iteration.
Return the final value of the accumulator.
If "it" is nil, returns a partially-applied function with the
reduce function and, if provided, the accumulator value.

### `fn.taken(n, it, inv, ctl)`

Take the first n results of iterator it.
Return a new iterator that takes at most those first n results.
If "it" is nil, returns a partially-applied function with the n
value set.

### `fn.takewhile(p, it, inv, ctl)`

Take the iterator's it results while the predicate p returns true.
The predicate is called with the values of each iteration.
Return a new iterator that applies the take while condition.
If "it" is nil, returns a partially-applied function with the predicate
p set.

### `fn.skipn(n, it, inv, ctl)`

Skip the first n results of iterator it.
Return a new iterator that skips those first n results.
If "it" is nil, returns a partially-applied function with the n
value set.

### `fn.skipwhile(p, it, inv, ctl)`

Skip the iterator's it results while the predicate p returns true.
The predicate is called with the values of each iteration.
Return a new iterator that applies the skip while condition.
If "it" is nil, returns a partially-applied function with the predicate
p set.

### `fn.any(p, it, inv, ctl)`

Any calls predicate p with all values of each iteration of it and
returns true as soon as p returns true, along with the index of the
iteration that returned true and all its values.
It returns false as the only value if the iteration is completed
without p returning true.
If "it" is nil, returns a partially-applied function with the predicate
p set.

### `fn.all(p, it, inv, ctl)`

All calls predicate p with all values of each iteration of it and
returns false as soon as p returns false, along with the index of the
iteration that returned false and all its values.
It returns true as the only value if the iteration is completed without
p returning false.
If "it" is nil, returns a partially-applied function with the predicate
p set.

### `fn.concat(...)`

Concat concatenates the provided iterators together, returning
a new iterator that loops through all iterators in a single
sequence. The arguments must be provided as a list of tables,
each table an array containing the iterator tuple (i.e. the
iterator function, its invariant value and its control value).
A common way to generate this is e.g.:
  `fn.concat({pairs(t1)}, {pairs(t2)})`
Another option is with table.pack (the 'n' field is used if
it is set):
  `fn.concat(table.pack(pairs(t1)), table.pack(pairs(t2)))`

### `fn.zip(...)`

Zip returns an iterator that returns the first value of all iterators at
each iteration step. All iterators are iterated together at the same time,
and iteration ends when the first iterator ends. If other iterators end
earlier, the nil value is returned for this iterator.

The arguments must be provided as a list of tables, each table an array
containing the iterator tuple (see documentation for concat for more
details).

### `fn.unzip(it, inv, ctl)`

Unzip takes a single iterator and returns a new iterator that produces a
single value on each iteration. The original iterator advances only when
all its returned values for a given step have been returned as single-value
iteration steps. Note that any nil value in the values returned by the
original iterator will stop the new iterator early, as nil are possible
only when not the first return value in a Lua iterator (otherwise they
indicate the end of iteration).

### `fn.select(n, it, inv, ctl)`

Select takes a single iterator and returns a new iterator that produces
the value(s) of the original iterator specified by n, which can be:
    * A number, indicating the 1-based index of the value to select
    * An array, indicating the 1-based indices of the values to select,
      returned in the array's order.
    * A function that will receive the original iterator's values and
      return its returned values instead (same as map).

It is a specialized form of map. If "it" is nil, returns a partially-applied
function with "n" set.

### `fn.collectarray(t, it, inv, ctl)`

Collects the first value of the iterator into an array, appending to t on
each iteration. If t is nil, a new table is created. If "it" is nil, returns
a partially-applied function with "t" set. This function consumes the
iterator and returns t, it is a special case of reduce.

To collect multiple values from the iterator in an array, pipe from pack,
select or map.

### `fn.collectkv(t, it, inv, ctl)`

Collects the first two values of the iterator in a table, the first value
being used as the key and the second as the value. If t is nil, a new table
is created. If "it" is nil, returns a partially-applied function with "t"
set. This function consumes the iterator and returns t, it is a special case
of reduce.

To rearrange order of the iterator's values, see select.

### `fn.pack(it, inv, ctl)`

Packs takes an iterator and returns a new iterator that packs all values
from the original iterator into an array and returns that array as iteration
value instead. It is a specialized form of map.

### `fn.callmethod(m, args, t, ...)`

Callmethod calls the method m on table t, passing the args
an any additional arguments received after t. The args
parameter is treated as a "packed" table, it is unpacked when
t.m is called, and the rest of the arguments (after t) are
passed after the unpacked args. This is so that callmethod
can be partially applied with some arguments before receiving
the table instance on which to call the method.
If t is nil, returns a partially-applied function with the
method name m and (if non-nil) the args table set. Pass an empty
table (and not nil) as args if there are no arguments to provide.

## Development

Clone the project and install the required development dependencies:

* luaunit (unit test runner)
* luacov (recommended, test coverage)
* luabenchmark (to run benchmarks)

If like me you prefer to keep your dependencies locally, per-project, then I recommend using my [llrocks] wrapper of the `luarocks` cli, which by default uses a local `lua_modules/` tree.

```
$ llrocks install ...
```

To run tests and benchmarks:

```
$ llrocks run fn_test.lua
$ llrocks run bench/*.lua
```

To view code coverage:

```
$ llrocks cover fn_test.lua
```

## License

The [BSD 3-clause][bsd] license.

[bsd]: http://opensource.org/licenses/BSD-3-Clause
[llrocks]: https://git.sr.ht/~mna/llrocks
