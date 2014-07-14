require("egg")

LEFT_SECTION = 1
CENTER_SECTION = 2
RIGHT_SECTION = 3

function love.load() 
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	sectionWidth = screenWidth / 3

	eggs = {}

	eggLastAdded = 0

	playerSection = 2

	playerCaughtEggs = 0
end

function love.update(dt)
	-- add eggs if needed
	-- for now, add another every second

	if (eggLastAdded > 1) then
		eggLastAdded = 0
		table.insert(eggs, Egg.create())
	end

	eggLastAdded = eggLastAdded + dt

	-- check for player section
	if love.mouse.isDown('l') then
		checkPlayerSection()
	else 
		playerSection = CENTER_SECTION
	end

	-- update egg positions
	for key, value in ipairs(eggs) do
		value:move(dt)

		if value.section == playerSection and value.collectable then
			-- credit the player with catching the egg
			playerCaughtEggs = playerCaughtEggs + 1

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

function love.draw()
	love.graphics.push()
	love.graphics.scale(scaleWidth, scaleHeight)

	-- draw score
	love.graphics.print(playerCaughtEggs, 20, 20)

	-- draw lines for sections
    love.graphics.line(sectionWidth, 0, sectionWidth, 600)
    love.graphics.line(screenWidth - sectionWidth, 0, screenWidth - sectionWidth, 600)

    -- draw the eggs
	for key, value in ipairs(eggs) do
		value:draw()
	end

	-- draw the player
	

	love.graphics.pop()
end

function checkPlayerSection()
	if love.mouse.getX() > 0 and love.mouse.getX() < sectionWidth then
		playerSection = LEFT_SECTION
	elseif love.mouse.getX() > screenWidth - sectionWidth and love.mouse.getX() < screenWidth then
		playerSection = RIGHT_SECTION
	else
		playerSection = CENTER_SECTION
	end
end

function love.resize(w, h)
	scaleWidth = w / 800
	scaleHeight = h / 576
end