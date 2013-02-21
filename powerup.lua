
local stateNotPickedUp = 1
local statePickedUp = 2

Powerup = class('Powerup')

function Powerup:initialize()
	self.startFunc = function(p) end
	self.endFunc = function(p) end
	self.player = nil
	self.cooldown = 0.0
	self.done = false
	
	self.pos = { x = 0, y = 0 }
	self.size = 16
	self.state = stateNotPickedUp
	
	self:initializeRandom()
end

function Powerup:isPickedUp()
	return self.state == statePickedUp
end

function Powerup:initializeRandom()
	self:setPosition(math.random(1, 800), math.random(1,600))
	
	local id = math.random(1,1000)
	

	self.cooldown, self.startFunc, self.endFunc = createShieldEffect()

	
	if id < 100 then
		self.cooldown, self.startFunc, self.endFunc = createInvertDirection()
	elseif id < 600 then
		self.cooldown, self.startFunc, self.endFunc = createSpeedEffect()
	elseif id < 700 then
		self.cooldown, self.startFunc, self.endFunc = createInvertRotation()
	elseif id < 800 then
		self.cooldown, self.startFunc, self.endFunc = createRotationSpeed()
	else
		self.cooldown, self.startFunc, self.endFunc = createShieldEffect()
	end
end

function Powerup:setPosition(px,py)
	self.pos.x = px
	self.pos.y = py
end

function Powerup:pickup(player)
	self.player = player
	self:start()
	self.state = statePickedUp
end

function Powerup:update(dt)
	if not done then 
		if statePickedUp == self.state then
			self.cooldown = self.cooldown - dt
			
			if self.cooldown <= 0 then
				self:stop()
			end
		end
	end
end

function Powerup:start()
	self.startFunc(self.player)
	--cron.after(2, self:stop)
end

function Powerup:stop()
	self.endFunc(self.player)
	self.done = true
end

function Powerup:draw()
	if stateNotPickedUp == self.state then
		-- draw
		love.graphics.draw(images["powerup"], self.pos.x, self.pos.y)
	end
end

function createSpeedEffect()
	local startFunction = function(p) p.speed = p.speed * 2.0 end
	local endFunction = function(p) p.speed = p.speed * 0.5 end
	
	if math.random() < 0.75 then	
		return 8.00, startFunction, endFunction
	else
		return 8.00, endFunction, startFunction
	end
end

function createShieldEffect()
	local startFunction = function(p) 
		p.scale = p.scale * 2.0
		--player.size = player.size * 2.0
	end
	local endFunction = function(p) 
		p.scale = p.scale * 0.5
		--player.size = player.size * 0.5
	end
	
	if math.random() < 0.75 then	
		return 8.00, startFunction, endFunction
	else
		return 8.00, endFunction, startFunction
	end
end

function createInvertRotation()
	local startFunction = function(p) p.invRot = not p.invRot end
	local endFunction = function(p) p.invRot = not p.invRot end
	
	return 16.0, startFunction, endFunction
end

function createRotationSpeed()
	local startFunction = function(p) p.rotSpeed = p.rotSpeed * (3.0/2.0) end
	local endFunction = function(p) p.rotSpeed = p.rotSpeed * (2.0/3.0) end
	
	if math.random() < 0.5 then	
		return 8.00, startFunction, endFunction
	else
		return 8.00, endFunction, startFunction
	end
end

function createInvertDirection()
	local startFunc = function(p) p.invDir = not p.invDir end
	local endFunc = function(p) p.invDir = not p.invDir end
	
	return 8.0, startFunc, endFunc
end
