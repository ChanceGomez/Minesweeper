--[[

	Program: Mine Sweeper
	Programmer: Chance Gomez | chance.f.gomez@gmail.com
	File: Main.lua

]]

-- Variables

	--scripts
	board 		= nil
	consumables = nil
	
	--libraries
	controls 	= nil
	buttons 	= nil
	assetloader = nil
	infopanel 	= nil
	animator 	= nil
	
	--scenes
	game 		= nil
	settings 	= nil
	shop 		= nil
	main_menu 	= nil
	credits 	= nil
	selection	= nil

	
	--font assets
	amiri_bold_italic_64 	= nil
	amiri_bold_italic_16 	= nil
	amiri_16 				= nil
	
	--
	scenes = {
		game = { 
			x = 0,
			y = 0,
			draw = function(self)
				game:draw(self.x,self.y)
			end,
			update = function(self)
				game:update(dt,self.x,self.y)
			end,
			load = function()
				game:load()
			end,
		},
		settings = {
			x = 0,
			y = 0,
			draw = function(self)
				settings:draw(self.x,self.y)
			end,
			update = function(self)
				settings:update(dt,self.x,self.y)
			end,
			load = function()
				settings:load()
			end,
		},
		mainmenu = {
			x = 0,
			y = 0,
			draw = function(self)
				main_menu:draw(self.x,self.y)
			end,
			update = function(self)
				main_menu:update(dt,self.x,self.y)
			end,
			load = function(self)
				main_menu:load()
			end,
		},
		credits = { -- credits
			x = 0,
			y = 0,
			draw = function(self)
				credits:draw(self.x,self.y)
			end,
			update = function(self)
				credits:update(dt,self.x,self.y)
			end,
			load = function(self)
				credits:load()
			end,
		},
	}
	scene = "mainmenu"
	seed = 1
	buttons = {}
	WIDTH,HEIGHT = 640,360
	SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions(1)
	SCALE = 3
	cursorX,cursorY = 0,0
	leftClick = false
	rightClick = false
	dt = 0
	buttons = {}
	fullscreen = true
	border = true
	
function isHovered(obj,x,y)
	local x = x or 0
	local y = y or 0
	return cursorX >= (obj.x + x) and cursorX <= (obj.x + x + obj.width) and
	       cursorY >= (obj.y + y) and cursorY <= (obj.y + y + obj.height)
end

function love.load()
--get new seed
	math.randomseed(seed)
	math.random()
	print("seed: " .. seed)
--graphics
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setVSync(0)
	
--libraries
	controls 	= require'libraries/textfields/controls'
	buttons 	= require'libraries/buttons'
	assetloader = require'libraries/assetloader'
	infopanel 	= require'libraries/infopanel'
	animator 	= require'libraries/animator'
	
--libraries load
	assetloader:loadImages('assets/sprites')
	assetloader:loadAnimations('assets/sprites/animations')
	infopanel:load()

--scripts
	board 		= require'scripts/board'
	
--scenes
	game 		= require'scenes/game'
	settings 	= require'scenes/settings'
	main_menu 	= require'scenes/main_menu'
	credits 	= require'scenes/credits'
	
--canvas
	mainCanvas 	= love.graphics.newCanvas(WIDTH,HEIGHT)

	--font assets
	perfect_dos_16 = love.graphics.newFont('assets/fonts/perfect_dos_vga_437/Perfect DOS VGA 437.ttf',16)
	perfect_dos_32 = love.graphics.newFont('assets/fonts/perfect_dos_vga_437/Perfect DOS VGA 437.ttf',32)
	perfect_dos_64 = love.graphics.newFont('assets/fonts/perfect_dos_vga_437/Perfect DOS VGA 437.ttf',64)
	
	--Scripts loader
	board:load()

	-- Scene Updater
	for i, scene in pairs(scenes) do
		scenes[i]:load()
	end
end

function love.update(dt)
	-- timer
	dt = dt
	animator:update(dt)
	--debug
	if love.keyboard.isDown'escape' then
		love.event.quit()
	end
	--cursor
	cursorX,cursorY = love.mouse.getPosition()
	cursorX,cursorY = cursorX / SCALE, cursorY / SCALE
	
	-- Scene Updater
	scenes[scene]:update(dt)
	
	--libraries
	
	
	controls:update()
	--cursor
	leftClick = false
	rightClick = false
end

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	love.graphics.clear()
	
	--Scene Drawer 
	scenes[scene]:draw(x,y)


	--libraries

	love.graphics.setFont(perfect_dos_16)
	--love.graphics.print(love.timer.getFPS(),640-27,1)
	
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(mainCanvas,0,0,0,SCALE)
end