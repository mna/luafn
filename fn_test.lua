local lu = require 'luaunit'

TestAll = require 'tests.all'
TestAny = require 'tests.any'
TestCallMethod = require 'tests.callmethod'
TestCollectArray = require 'tests.collectarray'
TestCollectKV = require 'tests.collectkv'
TestConcat = require 'tests.concat'
TestFilter = require 'tests.filter'
TestFromTo = require 'tests.fromto'
TestMap = require 'tests.map'
TestPack = require 'tests.pack'
TestPartial = require 'tests.partial'
TestPartialTrail = require 'tests.partialtrail'
TestPipe = require 'tests.pipe'
TestReduce = require 'tests.reduce'
TestSelect = require 'tests.select'
TestSkipn = require 'tests.skipn'
TestSkipWhile = require 'tests.skipwhile'
TestTaken = require 'tests.taken'
TestTakeWhile = require 'tests.takewhile'
TestUnzip = require 'tests.unzip'
TestUseCases = require 'tests.usecases'
TestZip = require 'tests.zip'

os.exit(lu.LuaUnit.run())
