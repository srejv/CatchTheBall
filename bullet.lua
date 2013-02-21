

Bullet = class('Bullet')

function Bullet:initialize(player)
	self.player = player
	self.speed = 500
	self.color = player.color
	self.x = player.pos.x
	self.y = player.pos.y
	self.rot = player.rot
	self.ax = player.acc.x
	self.ay = player.acc.y

	self.x = self.x + self.ax * 80;
	self.y = self.y + self.ay * 80;
end

function Bullet:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b)
	love.graphics.draw(images['bullet'], math.floor(self.x), 
		math.floor(self.y),
		self.rot)
end

function Bullet:update(dt)
	self.x = self.x + self.ax * self.speed * dt;
	self.y = self.y + self.ay * self.speed * dt;
	
end


function Bullet:onHit(otherPlayer)
	if otherPlayer.points > 0 then
		self.player.points = self.player.points + 1
		otherPlayer.points = otherPlayer.points - 1
	end
end