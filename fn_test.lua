local lu = require 'luaunit'

TestAll = require 'tests.all'
TestAny = require 'tests.any'
TestCallMethod = require 'tests.callmethod'
TestConcat = require 'tests.concat'
TestFilter = require 'tests.filter'
TestFromTo = require 'tests.fromto'
TestMap = require 'tests.map'
TestPartial = require 'tests.partial'
TestPipe = require 'tests.pipe'
TestReduce = require 'tests.reduce'
TestSkipn = require 'tests.skipn'
TestSkipWhile = require 'tests.skipwhile'
TestTaken = require 'tests.taken'
TestTakeWhile = require 'tests.takewhile'
TestUseCases = require 'tests.usecases'

os.exit(lu.LuaUnit.run())
