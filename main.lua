platform = {}
terrain = {}
player = {}

function checkCollisions(player, bullets)
	for i, b in pairs(bullets) do
		if b.x < player.x + 20 and b.x > player.x and b.y < player.y + 0 and b.y > player.y - 15 then
			table.remove(bullets, i)
		end
	end
end

function checkCollisionsBlocks(player, blocks)
	for i, block in pairs(blocks) do
		--print(block.x)
	end
end
 
function love.load()
	terrain.blocks = {}
	block = {}
	block.x = 200
	block.y = 250
	block.width = 60
	block.height = 20
	table.insert(terrain.blocks, block)

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

	player.hitbox = {}
	player.hitbox.x = player.x+11
	player.hitbox.y = player.y
	player.hitbox.width = 10
	player.hitbox.height = 10
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
	player.hitbox.x = player.x+11
	player.hitbox.y = player.y

	checkCollisions(player, player.bullets)
	checkCollisionsBlocks(player, terrain.blocks)

	t = t + dt
	player.cooldown = player.cooldown - 1
	if love.keyboard.isDown('d') then
		if player.hitbox.x < (terrain.blocks[1].x - player.hitbox.width) or (player.hitbox.x) > (terrain.blocks[1].x + terrain.blocks[1].width) or player.hitbox.y < terrain.blocks[1].y or player.hitbox.y > (terrain.blocks[1].y + terrain.blocks[1].height) then
			player.x = player.x + (player.speed * dt)
		end
	elseif love.keyboard.isDown('a') then
		if player.hitbox.x < (terrain.blocks[1].x - player.hitbox.width) or (player.hitbox.x) > (terrain.blocks[1].x + terrain.blocks[1].width) or player.hitbox.y < terrain.blocks[1].y or player.hitbox.y > (terrain.blocks[1].y + terrain.blocks[1].height) then 
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
	love.graphics.print(p/t)

	-- Draw Terrain
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
	love.graphics.rectangle('fill', terrain.blocks[1].x, terrain.blocks[1].y, terrain.blocks[1].width, terrain.blocks[1].height)
 
 	-- Draw Player
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)

	-- Draw Bullets 
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, 3, 2)
	end
end