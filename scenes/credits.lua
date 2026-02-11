local credits = {
	buttons = {},
}





function credits:load()
	--
	creditsCanvas =love.graphics.newCanvas(WIDTH,HEIGHT)
	
	--buttons
	self.buttons['back'] = {
		x = 640-20-32,
		y = 20,
		color = {1,1,1,1},
		image = assetloader:getImage('back_button'),
		hoveredImage = assetloader:getImage('back_button_hovered'),
		width = assetloader:getImage('back_button'):getWidth(),
		height = assetloader:getImage('back_button'):getHeight(),
		visible = true,
		clicked = function()
			scene = "mainmenu"
		end
	}
end

function credits:update(dt,canvasX,canvasY)
	buttons:update(self.buttons)
end

function credits:draw(canvasX,canvasY)
	--canvas
	love.graphics.setCanvas(creditsCanvas)
	love.graphics.clear()


	buttons:draw(self.buttons,canvasX,canvasY)
	
	--credits
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(perfect_dos_16)
	love.graphics.print('Programmer: Chance Gomez | chance.f.gomez@gmail.com')
	love.graphics.print('Fonts: perfect dos vga 437 by: Zeh Fernando',0,18)
	love.graphics.print('Art Based Program: asesprite',0,36)
	love.graphics.print('Game Engine: Love2D Framework',0,52)
	love.graphics.print('Language: Lua',0,70)


	love.graphics.setCanvas(mainCanvas)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(creditsCanvas,canvasX,canvasY)
end



return credits