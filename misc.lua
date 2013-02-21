
screenSize = { minx = -32, miny = -32, maxx = 832, maxy = 632 }

-- Check if inside circle, true if it is
function inCircle(x,y, center_x, center_y, radius)
	local dx, dy = x - center_x, y - center_y
	if dx*dx + dy*dy < (radius * radius) then
		return true
	end	
	return false
end

-- Converts HSL to RGB. (input and output range: 0 - 255)
function HSL(h, s, l, a)
    if s<=0 then return l,l,l,a end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

function getPlayerKey(id)
	if id == 1 then
		return 'a'
	elseif id == 2 then
		return 'l'
	elseif id == 3 then
		return 'c'
	elseif id == 4 then
		return 'n'
	elseif id == 5 then
		return 'r'
	elseif id == 6 then
		return 'u'
	end

	return 'q'
end

function comparePoints(a, b)
	return a.points > b.points
end

function wrap(o) 
	if o.pos.x > screenSize.maxx  then
		o.pos.x = screenSize.minx
	elseif o.pos.x < screenSize.minx then
		o.pos.x = screenSize.maxx
	end
	
	if o.pos.y > screenSize.maxy then
		o.pos.y = screenSize.miny
	elseif o.pos.y < screenSize.miny then
		o.pos.y = screenSize.maxy
	end
end

function wrap2(o) 
	if o.x > screenSize.maxx  then
		o.x = screenSize.minx
	elseif o.x < screenSize.minx then
		o.x = screenSize.maxx
	end
	
	if o.y > screenSize.maxy then
		o.y = screenSize.miny
	elseif o.y < screenSize.miny then
		o.y = screenSize.maxy
	end
end
