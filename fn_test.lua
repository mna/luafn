local lu = require 'luaunit'

TestFromTo = require 'tests.fromto'
TestFilter = require 'tests.filter'
TestMap = require 'tests.map'

os.exit(lu.LuaUnit.run())
