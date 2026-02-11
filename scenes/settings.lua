local settings = {
	buttons = {}
}


function settings:load()
	--canvas
	settingsCanvas = love.graphics.newCanvas(WIDTH,HEIGHT)

	--buttons
	settings.buttons['fullscreen'] = {
		x = 20,
		y = 20,
		color = {1,1,1,1},
		image = assetloader:getImage('fullscreen_button'),
		hoveredImage = assetloader:getImage('fullscreen_button_hovered'),
		width = assetloader:getImage('fullscreen_button'):getWidth(),
		height = assetloader:getImage('fullscreen_button'):getHeight(),
		visible = true,
		description = "Enable or disable fullscreen",
		clicked = function()
			fullscreen = not fullscreen
			if not fullscreen then
				SCALE = 1
			else 
				local width,height = love.window.getMode()
				SCALE = SCREEN_WIDTH/WIDTH
			end
			love.window.setFullscreen(fullscreen)
		end
	}
	settings.buttons['border'] = {
		x = 20,
		y = 20+32+8,
		color = {1,1,1,1},
		image = assetloader:getImage('border_button'),
		hoveredImage = assetloader:getImage('border_button_hovered'),
		width = assetloader:getImage('border_button'):getWidth(),
		height = assetloader:getImage('border_button'):getHeight(),
		visible = true,
		description = "Enable or disable border",
		clicked = function()
			local width,height = WIDTH,HEIGHT
			if fullscreen then
				width,height = SCREEN_WIDTH,SCREEN_HEIGHT
			end
			border = not border
			love.window.setMode(width, height, { borderless = border })			
		end
	}
	
	settings.buttons['restart'] = {
		x = 20,
		y = 20+32+8+32+8,
		color = {1,1,1,1},
		image = assetloader:getImage('restart_button'),
		hoveredImage = assetloader:getImage('restart_button_hovered'),
		width = assetloader:getImage('restart_button'):getWidth(),
		height = assetloader:getImage('restart_button'):getHeight(),
		visible = true,
		description = "Restart board",
		clicked = function()
			board:reset()
		end
	}
	settings.buttons['exit'] = {
		x = 20,
		y = 20+32+8+32+8+32+8,
		color = {1,1,1,1},
		image = assetloader:getImage('exit_button'),
		hoveredImage = assetloader:getImage('exit_button_hovered'),
		width = assetloader:getImage('exit_button'):getWidth(),
		height = assetloader:getImage('exit_button'):getHeight(),
		visible = true,
		description = "Exit game",
		clicked = function()
			love.event.quit()
		end
	}
	settings.buttons['back'] = {
		x = 640-20-32,
		y = 20,
		color = {1,1,1,1},
		image = assetloader:getImage('back_button'),
		hoveredImage = assetloader:getImage('back_button_hovered'),
		width = assetloader:getImage('back_button'):getWidth(),
		height = assetloader:getImage('back_button'):getHeight(),
		visible = true,
		description = "back",
		clicked = function()
			scene = "mainmenu"	
		end
	}
end

function settings:update(dt,canvasX,canvasY)

	buttons:update(settings.buttons,canvasX,canvasY)
	

end

function settings:draw(canvasX,canvasY)
	--canvas
	love.graphics.setCanvas(settingsCanvas)
	love.graphics.clear()


	buttons:draw(settings.buttons,canvasX,canvasY)

	for i, button in pairs(self.buttons) do
		infopanel:draw(button)
	end
	
	
	love.graphics.setCanvas(mainCanvas)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(settingsCanvas,canvasX,canvasY)
end






return settings