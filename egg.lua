Egg = {}
Egg.__index = Egg

math.randomseed(os.time())

local gravity = 10

function Egg.create(levelAcceleration)
   local egg = {}             -- our new object
   setmetatable(egg,Egg)  
   egg.section = math.random(1, 3)
   egg.x = (sectionWidth / 2) + ((egg.section - 1) * sectionWidth) 
   egg.y = 0
   egg.dy = 70 + levelAcceleration
   egg.visible = true
   egg.collectable = false
   return egg
end

function Egg:draw()
	love.graphics.push()
	local r, g, b, a = love.graphics.getColor()
	
	love.graphics.translate(self.x, self.y)

	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", 0, 0, sectionWidth / 10, sectionWidth / 10)
	love.graphics.setColor(r, g, b, a)
	
	love.graphics.pop()

	self:checkOffScreen()
	self:checkCollectable()
end

function Egg:move(dt)
	self.dy = self.dy + gravity
	self.y = self.y + (self.dy * dt)
end

function Egg:checkOffScreen()
	if self.y > screenHeight then
		self.visible = false
	end
end

-- is this egg in the region that can be picked up by the player?
function Egg:checkCollectable()
	if self.y < screenHeight and self.y > screenHeight - 40 then
		self.collectable = true
	end
end