Level = {}
Level.__index = Level

function Level.create(index, eggAcceleration, eggAccelerationIncrement, baseEggDropRate, eggDropRateAcceleration, eggTotal)
   local level = {}             -- our new object
   setmetatable(level, Level)  

   level.index = index

   level.initialEggAcceleration = eggAcceleration
   level.eggAcceleration = eggAcceleration
   level.eggAccelerationIncrement = eggAccelerationIncrement

   level.baseEggDropRate = baseEggDropRate 
   level.eggDropRateAcceleration = eggDropRateAcceleration

   level.eggTotal = eggTotal

   return level
end

function Level:update(dt)
   self.eggAcceleration = self.eggAcceleration + self.eggAccelerationIncrement
end