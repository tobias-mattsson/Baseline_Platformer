platform = {}
player = {}

function checkCollisions(player, bullets)
	for i, b in pairs(bullets) do
		if b.x < player.x + 20 and b.x > player.x and b.y < player.y + 0 and b.y > player.y - 15 then
			table.remove(bullets, i)
		end
	end
end
 
function love.load()
	platform.width = love.graphics.getWidth()
	platform.height = love.graphics.getHeight()
 
	platform.x = 0
	platform.y = platform.height / 2
 
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
 
	player.speed = 200
 
	player.img = love.graphics.newImage('purple.png')
 
	player.ground = player.y
 
	player.y_velocity = 0
 
	player.jump_height = -300
	player.gravity = -800

	player.bullets = {}
	player.cooldown = 20
	player.fire = function()
		if player.cooldown <= 0 then
			player.cooldown = 20
			bullet = {}
			bullet.direction = 1
			bullet.x = player.x + 22
			bullet.y = player.y - 14
			table.insert(player.bullets, bullet)
		end
	end

	p = 0
	t = 0
end
 
function love.update(dt)

	checkCollisions(player, player.bullets)

	t = dt
	t = 1/t
	player.cooldown = player.cooldown - 1
	if love.keyboard.isDown('d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed * dt)
		end
	elseif love.keyboard.isDown('a') then
		if player.x > 0 then 
			player.x = player.x - (player.speed * dt)
		end
	end
 
	if love.keyboard.isDown('space') then
		if player.y_velocity == 0 then
			player.y_velocity = player.jump_height
		end
	end

	if love.keyboard.isDown('rctrl') then
		player.fire()
	end

	function love.keyreleased(key)
   		if key == 'rctrl' then
      		player.cooldown = 0
   		end
	end

	if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end
 
	if player.y > player.ground then
		player.y_velocity = 0
    	player.y = player.ground
	end

	for i,b in ipairs(player.bullets) do
		if b.x > platform.width then
			b.direction = -1
		elseif b.x < 0 then
			table.remove(player.bullets, i)
			p = p + 1
		end
		b.x = b.x + b.direction*5
	end
end
 
function love.draw()
	-- Draw Statistics
	love.graphics.print(p)

	-- Draw Terrain
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
 
 	-- Draw Player
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)

	-- Draw Bullets 
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, 3, 2)
	end
end