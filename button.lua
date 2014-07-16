Button = {}
Button.__index = Button

function Button.create(x, y, text)
   local button = {}             -- our new object
   setmetatable(button, Button)  
   
   button.width = 150
   button.height = 50

   button.x = x - button.width / 2
   button.y = y - button.height / 2
   button.text = text

   button.type = 'start'

   -- button colors
   button.r = 0
   button.g = 255
   button.b = 0
   return button
end

function Button:draw()
	love.graphics.push()
	love.graphics.translate(self.x, self.y)

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.r, self.g, self.b, 200)

	love.graphics.rectangle("fill", 0, 0, 150, 50)

	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.text, 10, self.height / 2 - 7)

	love.graphics.setColor(r, g, b, a)
	love.graphics.pop()
end

function Button:mousepressed(x, y)
	if x > self.x and x < self.x + self.width then
		if y > self.y and y < self.y + self.height then
			if self.type == 'start' then
				startGame()
			elseif self.type == 'restart' then
				restartGame()
			end
		end
	end
end