require("player")
require("egg")

LEFT_SECTION = 1
CENTER_SECTION = 2
RIGHT_SECTION = 3

function love.load() 
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	sectionWidth = screenWidth / 3

	player = Player.create()

	eggs = {}
	eggLastAdded = 0
	dropEggs = true
	totalEggsDropped = 0
end

function love.update(dt)
	addEggs(dt)

	-- check for player section
	if love.mouse.isDown('l') then
		player:checkSection()
	else 
		player.section = CENTER_SECTION
	end

	updateEggs(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(scaleWidth, scaleHeight)

	-- draw score
	love.graphics.print(player.caughtEggs, 20, 20)

	-- draw lines for sections
    love.graphics.line(sectionWidth, 0, sectionWidth, screenHeight)
    love.graphics.line(screenWidth - sectionWidth, 0, screenWidth - sectionWidth, screenHeight)

    -- draw the eggs
	for key, value in ipairs(eggs) do
		value:draw()
	end

	-- draw the player
	player:updatePosition()
	love.graphics.rectangle("fill", player.x, player.y, 50, 50)

	love.graphics.pop()
end

function addEggs(dt)
	-- add eggs if needed
	-- for now, add another every second
	if (eggLastAdded > 1 and dropEggs) then
		eggLastAdded = 0
		table.insert(eggs, Egg.create())
		totalEggsDropped = totalEggsDropped + 1
		if totalEggsDropped >= 10 then
			dropEggs = false
		end
	end

	eggLastAdded = eggLastAdded + dt
end

function updateEggs(dt)
	-- update egg positions
	for key, value in ipairs(eggs) do
		value:move(dt)

		if value.section == player.section and value.collectable then
			-- credit the player with catching the egg
			player.caughtEggs = player.caughtEggs + 1

			-- remove the egg from the model
			table.remove(eggs, key)
		end

		-- clean up eggs that have fallen off screen
		-- also, maybe remove points from the player or do something
		if not value.visible then
			table.remove(eggs, key)
		end
	end
end

function checkGameEnd()

end

function love.resize(w, h)
	scaleWidth = w / 800
	scaleHeight = h / 576
end