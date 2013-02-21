local twoPi = 6.283185307
local defaultSpeed = 250
local radie = 32 --px player radie
local stdRot = 3.14/2

Player = class('Player')
function Player:initialize(nid)
	self.id = nid
	self.actionKey = getPlayerKey(nid)
	self.color = { r = 0, g = 0, b = 0 }
	
	self:reset()
end

function Player:reset()
	self.rot = 0.0 -- rotation
	self.pos = { x = math.random(0, 800), y = math.random(0, 600) }
	self.acc = { x = 0.0, y = 0.0 }
	self.scale = 1.0
	
	self.points = 0
	self.invDir = false
	self.invRot = false
	self.isMoving = false
	self.rotSpeed = twoPi
	self.speed = defaultSpeed
	self.size = radie
end

function Player:hitBall()
	self.points = self.points + 1
end

function Player:startMoving()
	if not self.isMoving then
		self.isMoving = true
	
		self.acc.x = math.cos(self.rot - stdRot)
		self.acc.y = math.sin(self.rot - stdRot)

		self:fireBullet()
	end
end

function Player:fireBullet()
	local b = Bullet:new(self)
	table.insert(bullets, b)
end

function Player:stopMoving()
	self.isMoving = false
end

function Player:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	love.graphics.draw(images["player"], math.floor(self.pos.x), math.floor(self.pos.y), 
		self.rot, self.scale, self.scale, self.size, self.size)
end

function Player:update(dt)
	if self.isMoving then
		self:move(dt)
		wrap(self)
	else
		self:rotate(dt)
	end
end

function Player:move(dt)
	if not self.invDir then
		self.pos.x = self.pos.x + (self.acc.x * self.speed * dt)
		self.pos.y = self.pos.y + (self.acc.y * self.speed * dt)
	else
		self.pos.x = self.pos.x - (self.acc.x * self.speed * dt)
		self.pos.y = self.pos.y - (self.acc.y * self.speed * dt)		
	end

end

function Player:rotate(dt)
	if not self.invRot then
		self.rot = self.rot + self.rotSpeed * dt
	else 
		self.rot = self.rot - self.rotSpeed * dt
	end
end
