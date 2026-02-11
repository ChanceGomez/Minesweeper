local main_menu = {
	buttons = {},
}


function main_menu:load()
	self.main_menuCanvas = love.graphics.newCanvas(WIDTH,HEIGHT)
	
	--buttons
	self.buttons['play'] = {
		x = 15,
		y = 360-64-15-64-15,
		color = {1,1,1,1},
		image = assetloader:getImage('play_button'),
		hoveredImage = assetloader:getImage('play_button_hovered'),
		width = assetloader:getImage('play_button'):getWidth(),
		height = assetloader:getImage('play_button'):getHeight(),
		visible = true,
		clicked = function()
			game:reset()
			scene = "game"
		end,
		hovered = false
	}
	self.buttons['credits'] = {
		x = 15,
		y = 360-64-15,
		color = {1,1,1,1},
		image = assetloader:getImage('credits_button'),
		hoveredImage = assetloader:getImage('credits_button_hovered'),
		width = assetloader:getImage('credits_button'):getWidth(),
		height = assetloader:getImage('credits_button'):getHeight(),
		visible = true,
		clicked = function()
			scene = "credits"
		end,
		hovered = false,
	}
	self.buttons['exit'] = {
		x = 640-32-15,
		y = 15,
		color = {1,1,1,1},
		image = assetloader:getImage('exit_button'),
		hoveredImage = assetloader:getImage('exit_button_hovered'),
		width = assetloader:getImage('exit_button'):getWidth(),
		height = assetloader:getImage('exit_button'):getHeight(),
		visible = true,
		clicked = function()
			love.event.quit()
		end,
		hovered = false,
	}
	self.buttons['settings'] = {
		x = 640-32-15,
		y = 15+32+8,
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
end

function main_menu:update(dt,canvasX,canvasY)
	buttons:update(self.buttons,canvasX,canvasY)
end

function main_menu:draw(canvasX,canvasY)
	love.graphics.setCanvas(self.main_menuCanvas)
	love.graphics.clear()
	
	buttons:draw(self.buttons,canvasX,canvasY)
	
	for i, button in pairs(self.buttons) do
		if button.hovered then
			infopanel:draw(button)
		end
	end
	
	
	love.graphics.setCanvas(mainCanvas)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.main_menuCanvas,canvasX,canvasY)
end


return main_menu