local lu = require 'luaunit'

TestFromTo = require 'tests.fromto'
TestFilter = require 'tests.filter'
TestMap = require 'tests.map'
TestReduce = require 'tests.reduce'
TestTaken = require 'tests.taken'
TestTakeWhile = require 'tests.takewhile'
TestSkipn = require 'tests.skipn'
TestSkipWhile = require 'tests.skipwhile'

os.exit(lu.LuaUnit.run())
