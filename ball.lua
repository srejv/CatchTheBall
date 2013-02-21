
Ball = class('Ball')

function Ball:initialize()
	self.pos = { x = 0, y = 0 }
	self.color = { r = 0, g = 0, b = 0 }
	self.size = 8
	self.offset = { x = 8, y = 8 }
end

function Ball:reset()
	self.pos.x, self.pos.y = math.random(1,800), math.random(1,600)
	self.color.r, self.color.g, self.color.b = HSL(math.random(1,255), 255, 127)
end

function Ball:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	love.graphics.draw(images["ball"], self.pos.x, self.pos.y, 0, 1.0, 1.0, 8, 8);
end