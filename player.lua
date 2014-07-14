Player = {}
Player.__index = Player

function Player.create()
   local player = {}             -- our new object
   setmetatable(player,Player)  

   player.section = CENTER_SECTION
   player.width = 50
   player.height = 50
   player.x = (sectionWidth / 2) + ((player.section - 1) * sectionWidth) - (player.width / 2) 
   player.y = screenHeight - 50

   player.caughtEggs = 0
   return player
end

function Player:checkSection() 
	if love.mouse.getX() > 0 and love.mouse.getX() < sectionWidth then
		self.section = LEFT_SECTION
	elseif love.mouse.getX() > screenWidth - sectionWidth and love.mouse.getX() < screenWidth then
		self.section = RIGHT_SECTION
	else
		self.section = CENTER_SECTION
	end
end

function Player:updatePosition()
	self.x = (sectionWidth / 2) + ((player.section - 1) * sectionWidth) - (player.width / 2) 
end