local game = {
	buttons = {}
}


function background_draw()
	love.graphics.setBackgroundColor(0,0,0,1)
end

function game:reset()
	board:reset()
	self.buttons['main menu'].visible = false
end

function game:load()
	--canvas
	gameCanvas = love.graphics.newCanvas(WIDTH,HEIGHT)
	
	--buttons
	self.buttons['settings'] = {
		x = 20,
		y = 20,
		color = {1,1,1,1},
		image = assetloader:getImage('settings_button'),
		hoveredImage = assetloader:getImage('settings_button_hovered'),
		width = assetloader:getImage('settings_button'):getWidth(),
		height = assetloader:getImage('settings_button'):getHeight(),
		visible = true,
		clicked = function()
			scene = "settings"
		end
	}
	self.buttons['main menu'] = {
		x = 640/2-256/2,
		y = 360-64-15,
		color = {1,1,1,1},
		image = assetloader:getImage('main_menu_button'),
		hoveredImage = assetloader:getImage('main_menu_button_hovered'),
		width = assetloader:getImage('main_menu_button'):getWidth(),
		height = assetloader:getImage('main_menu_button'):getHeight(),
		visible = false,
		clicked = function()
			scene = "mainmenu"
		end
	}
	--
	self:reset()
end

function game:update(dt,canvasX,canvasY)
	board:update(dt,canvasX,canvasY)
	-- buttons:update(game.buttons['settings'],canvasX,canvasY)
	buttons:update(game.buttons,canvasX,canvasY)
	
	
	--check game state 
	if board.won then
		scene = "mainmenu"
	end
	if board.lost then
		self.buttons['main menu'].visible = true
	end
end

function game:draw(canvasX,canvasY)
	--canvas
	love.graphics.setCanvas(gameCanvas)
	love.graphics.clear()


	background_draw()
	board:draw()
	
	
	if board.lost then
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
		love.graphics.setColor(0,0,0,1)
		love.graphics.setFont(perfect_dos_64)
		love.graphics.print("Failed",640/2-(6*64)/4,124)
	end
	
	
	--buttons
	buttons:draw(game.buttons,canvasX,canvasY)
	
	
	
	
	--stats
	local x = 60
	local y = 96
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(perfect_dos_16)
	love.graphics.print('mines: ' .. board.mines,x,y)
	love.graphics.print('flags: ' .. board.flags,x,y+24)
	love.graphics.print('clicks: ' .. board.clicks,x,y+48)
	
	
	love.graphics.setCanvas(mainCanvas)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(gameCanvas,canvasX,canvasY)
end

return game