require("player")
require("level")
require("egg")
require("button")

LEFT_SECTION = 1
CENTER_SECTION = 2
RIGHT_SECTION = 3

EGG_TOTAL = 15

GAME_STATES = {['START'] = 1, ['PLAYING'] = 2, ['END'] = 3, ['RESTART'] = 4}

LEVEL_EGG_DROP_ACCELERATION = 1
LEVEL_EGG_ACCELERATION = 1

function love.load() 
	local font = love.graphics.newFont(18)
	love.graphics.setFont(font)

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	sectionWidth = screenWidth / 3

	player = Player.create()

	currentLevel = Level.create()

	resetValues()

	currentState = GAME_STATES.START

	button = Button.create(screenWidth / 2, screenHeight / 2, "Start Game")
end

function love.update(dt)
	if currentState == GAME_STATES.START then

	elseif currentState == GAME_STATES.PLAYING then
		gameUpdateLoop(dt)
	
	elseif currentState == GAME_STATES.END then

	elseif currentState == GAME_STATES.RESTART then
		resetValues()

		currentState = GAME_STATES.PLAYING
	end

	LEVEL_EGG_ACCELERATION = LEVEL_EGG_ACCELERATION + 0.5
	currentLevel:update()
end

function love.draw()
	if currentState == GAME_STATES.START then
		button:draw()
	elseif currentState == GAME_STATES.PLAYING then
		gameDrawLoop()
	
	elseif currentState == GAME_STATES.END then
		button:draw()
	end
end

function gameUpdateLoop(dt)
		addEggs(dt)

		-- check for player section
		if love.mouse.isDown('l') then
			player:checkSection()
		else 
			player.section = CENTER_SECTION
		end

		updateEggs(dt)

		checkGameEnd()
end

function gameDrawLoop()
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
	love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

	love.graphics.pop()
end

function addEggs(dt)
	-- add eggs if needed
	-- for now, add another every second
	if (eggLastAdded > currentLevel.baseEggDropRate and dropEggs) then
		eggLastAdded = 0
		table.insert(eggs, Egg.create(currentLevel.eggAcceleration))
		totalEggsDropped = totalEggsDropped + 1
		
		if totalEggsDropped == currentLevel.eggTotal then
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

function startGame()
	currentState = GAME_STATES.PLAYING
end

function restartGame()
	currentState = GAME_STATES.RESTART
end

function resetValues()
	eggs = {}
	eggLastAdded = 0
	dropEggs = true
	totalEggsDropped = 0
	player.caughtEggs = 0

	currentLevel:reset()
end

function checkGameEnd()
	if totalEggsDropped == currentLevel.eggTotal and table.getn(eggs) == 0 then
		currentState = GAME_STATES.END
		button.text = "Replay?"
		button.type = "restart"
	end
end

function love.resize(w, h)
	scaleWidth = w / 800
	scaleHeight = h / 576

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	sectionWidth = screenWidth / 3
end

function love.mousepressed(x, y, b)
	-- forward to other mouse pressed handlers
	if b == 'l' then
		if currentState == GAME_STATES.START or currentState == GAME_STATES.END then
			button:mousepressed(x, y)
		end
	end 
end