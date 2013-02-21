
require 'middleclass'
require 'misc'
local cron = require 'cron'
require 'player'
require 'ball'
require 'game'
require 'powerup'
require 'bullet'


event = {}

function love.load()
	images = {}
	
	images["player"] = love.graphics.newImage("gfx/player.png")
	images["ball"] = love.graphics.newImage("gfx/ball.png")
	images["particle"] = love.graphics.newImage("gfx/pickup.png")
	images["powerup"] = love.graphics.newImage("gfx/powerup.png")
	images["bullet"] = love.graphics.newImage("gfx/bullet.png")
	
	sounds = {}
	
	sounds["powerup"] = love.audio.newSource("sfx/pickup_powerup.wav", "static")
	sounds["crash"] = love.audio.newSource("sfx/crash.wav", "static")
	sounds["star"] = love.audio.newSource("sfx/pickupstar.wav", "static")
	sounds["bgmusic"] = love.audio.newSource("sfx/beathoven_kukuoas.ogg", "stream")
	
	love.graphics.setBackgroundColor(240,240,240)

	bullets = {}
	
	game = Game:new()
end

function love.update(dt)
	game:update(dt)
	cron.update(dt)
end

function love.draw()
	game:draw()
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push("quit")
		return
	end
	
	game:keypressed(key)
end

function love.keyreleased(key, unicode)
	game:keyreleased(key)
end