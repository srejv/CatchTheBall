
local stateStartScreen = 1
local stateGameScreen = 2
local stateScoreScreen = 3

Game = class('Game')
function Game:initialize()
	self.players = {}
	self.ball = Ball:new()
	self.powerups = {}
	self.numberOfPlayers = 2
	self.goalScore = 20
	
	self.state = stateStartScreen
	self:loadParticleSystem()
	
	self.keyPresses = 0
end

function Game:newGame()

	for i,v in ipairs(self.players) do
		self.players[i] = nil
	end
	
	local inc = 255 / self.numberOfPlayers

	for i = 1, self.numberOfPlayers do
		self.players[i] = Player:new(i)
		local a = 0;
		self.players[i].color.r, self.players[i].color.g, self.players[i].color.b, a = HSL((i-1)*inc, 255, 128);
		--self.players[i].color.r, self.players[i].color.g, self.players[i].color.b = math.random(1,255),math.random(1,255),math.random(1,255)
	end
	
	self.state = stateGameScreen
	
	self.ball:reset()
	
	love.audio.play(sounds["bgmusic"])
	
	self:reset()
end

function Game:reset()
	for i,p in ipairs(self.players) do
		p:reset()
	end
	
	self.ball:reset()
	
	self.keyPresses = 0
end

function Game:checkEndGame()
	for i,p in ipairs(self.players) do
		if self.goalScore <= p.points then
			-- game ends
			self.state = stateScoreScreen
		end
	end
end

function Game:playerHitsPlayer(dt, player1, player2)
	if player1.points > player2.points then
		player1.move(-dt)
	elseif player1.points == player2.points then
		player1.move(-dt)
		player2.move(-dt)
	else
		player2.move(-dt)
	end
end

function Game:playerHitsBall(player)
	player:hitBall()
	self.ball:reset()
	self:checkEndGame()
	-- play audio
	love.audio.stop(sounds["star"])
	love.audio.play(sounds["star"])
	
	self.system:stop()
	self.system:setPosition(player.pos.x, player.pos.y);
	self.system:start()
end

function Game:playerHitsPowerup(player,powerup)
	powerup:setPlayer(player)
end

function Game:draw()
	if stateGameScreen == self.state then
		self:drawGameScreen()
	elseif stateStartScreen == self.state then
		self:drawStartScreen()
	else
		self:drawScoreScreen()
	end
end

function Game:update(dt)
	if stateGameScreen == self.state then
		self:updateGameScreen(dt)
	elseif stateStartScreen == self.state then
		self:updateStartScreen(dt)
	else
		self:updateScoreScreen(dt)
	end
end

function Game:keypressed(key)
	if stateGameScreen == self.state then
		for i,p in ipairs(self.players) do
			if key == p.actionKey then
				self.keyPresses = self.keyPresses + 1
				
				if self.keyPresses >= 2 * #self.players then
					self:createNewPowerup()
					self.keyPresses = self.keyPresses - 2 * #self.players
				end
				
				p:startMoving()
			end
		end
		return
	end
	
	
end

function Game:keyreleased(key)
	if stateGameScreen == self.state then
	
		for i,p in ipairs(self.players) do
			if key == p.actionKey then
				p:stopMoving()
			end
		end
		
	elseif stateStartScreen == self.state then
		
		if key == '1' then
			self.numberOfPlayers = 1
		elseif key == '2' then
			self.numberOfPlayers = 2
		elseif key == '3' then
			self.numberOfPlayers = 3
		elseif key == '4' then
			self.numberOfPlayers = 4
		elseif key == '5' then
			self.numberOfPlayers = 5
		elseif key == '6' then
			self.numberOfPlayers = 6
		end
		
		if key == 'left' then
			self.goalScore = self.goalScore - 1
			if self.goalScore < 0 then
				self.goalScore = 0
			end
		end
		
		if key == 'right' then
			self.goalScore = self.goalScore + 1
		end

		if key == ' ' then
			self:newGame()
		end
	else
		if key == ' ' then
			self.state = stateStartScreen
		end
	end
end

function Game:drawStartScreen()
	love.graphics.setColor(0,0,0)
	love.graphics.print("Start Game! Select number of players (1,2,3,4,5,6) and score goal (left,right).", 200, 200)
	love.graphics.print("Number of players: " .. game.numberOfPlayers, 200, 260)
	love.graphics.print("Score goal: " .. game.goalScore, 200, 280)
end

function Game:updateStartScreen(dt)
end

function Game:drawGameScreen()

	
	
	-- draw ball 
	self.ball:draw()
	
	-- draw powerup
	for i,p in ipairs(self.powerups) do
		p:draw()
	end
	
	for i,b in ipairs(bullets) do
		b:draw()
	end

	-- draw particle system
	love.graphics.draw(self.system, 0, 0)

	-- draw players
	for i,p in ipairs(self.players) do
		p:draw()
	end

	for i,p in ipairs(self.players) do 
		love.graphics.setColor(p.color.r, p.color.g, p.color.b)
		love.graphics.print(i .. "('" .. p.actionKey .. "'): " .. p.points, 10, 10 + 16*i)
	end
end

function Game:updateGameScreen(dt)
	local hit = false
	for i,p in ipairs(self.players) do
		p:update(dt)
		if inCircle(self.ball.pos.x, self.ball.pos.y, p.pos.x, p.pos.y, (p.size*p.scale) + self.ball.size) then
			self:playerHitsBall(p)
			hit = true
		end
		
		for i,pup in ipairs(self.powerups) do
			if not pup:isPickedUp() then
				if inCircle(pup.pos.x, pup.pos.y, p.pos.x, p.pos.y, (p.size*p.scale) + pup.size) then
					pup:pickup(p)
					love.audio.stop(sounds["powerup"])
					love.audio.play(sounds["powerup"])
				end
			end
		end

		for i,b in ipairs(bullets) do
			if inCircle(b.x,b.y, p.pos.x, p.pos.y, (p.size*p.scale) + 4) then
				b:onHit(p)
				table.remove(bullets, i)
			end
		end
	end

	for i,b in ipairs(bullets) do
		b:update(dt)

		if b.x > screenSize.maxx  or b.x < screenSize.minx or 
			b.y > screenSize.maxy or b.y < screenSize.miny then
			table.remove(bullets, i)
		end
	end

	-- player vs player collision quadtree? 
	
	if hit then
		table.sort(self.players, comparePoints)
	end

	for i,p in ipairs(self.powerups) do
		p:update(dt);

		if p.done then
			table.remove(self.powerups, i)
		end

	end
	


	-- check collisions
	self.system:update(dt)
end

function Game:drawScoreScreen()
	love.graphics.setColor(self.players[1].color.r, self.players[1].color.g, self.players[1].color.b)
	for i,p in ipairs(self.players) do
		love.graphics.print(i .. "('" .. p.actionKey .. "') score: " .. p.points, 300, 100 + 30*i)
	end
end

function Game:updateScoreScreen(dt)
end

function Game:loadParticleSystem()
	self.system = love.graphics.newParticleSystem(images["particle"], 25)
	self.system:setEmissionRate(100)
	self.system:setSpeed(300, 400)
	self.system:setGravity(0)
	self.system:setSizes(2, 1)
	self.system:setColors(255, 255, 255, 255, 58, 128, 255, 0)
	self.system:setLifetime(1)
	self.system:setParticleLife(1)
	self.system:setDirection(0)
	self.system:setSpread(360)
	self.system:stop()
end

function Game:createNewPowerup()
	local powerup = Powerup:new()
	table.insert(self.powerups, powerup)
end