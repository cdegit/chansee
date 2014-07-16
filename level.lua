Level = {}
Level.__index = Level

function Level.create()
   local level = {}             -- our new object
   setmetatable(level, Level)  

   level.eggAcceleration = 1

   level.baseEggDropRate = 1 -- once per second
   level.eggDropRateAcceleration = 1

   level.eggTotal = 15

   return level
end

function Level:update(dt)
   self.eggAcceleration = self.eggAcceleration + 0.5
end

function Level:reset()
   self.eggAcceleration = 1
end