--conf.lua

function love.conf(t)


	t.version = '11.5'
	t.console = true
	t.window.fullscreen = true
	t.window.width = 640
	t.window.title = "Mine Sweeper"
	t.window.height = 360
    t.window.borderless = true
	t.window.icon = "assets/sprites/window_icon.png"
	
	t.modules.physics = false
	
end
	