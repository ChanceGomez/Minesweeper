--[[
	programmer: Chance Gomez | chance.f.gomez@gmail.com
	file: 		buttons.lua
	purpose:	updates and draws buttons from scenes. 
]]

local buttons = {}

local function isHover(obj,x,y)
	x = x or 0
	y = y or 0
	return cursorX >= (obj.x + x) and cursorX <= (obj.x + x + obj.width) and
	       cursorY >= (obj.y + y) and cursorY <= (obj.y + y + obj.height)
end

function buttons:add(tbl,name,x,y,image,clicked,hovered)
	tbl[name] = {
		x = x,
		y = y,
		image = image,
	}
end

function buttons:update(tbl,x,y)
	local x = x or 0
	local y = y or 0
	
	for i, button in pairs(tbl) do
		local valid = true
		if not button.visible and button.visible ~= nil then
			valid = false
		end
		if valid then
			if isHover(button,x,y) and leftClick then
				button.hovered = true
				button:clicked()
			else
				button.hovered = false
			end
		end
	end
end


function buttons:draw(tbl,x,y)
	local x = x or 0
	local y = y or 0
	
	for i, button in pairs(tbl) do
		local buttonColor = button.color or {1,1,1,1}
	
	
		local valid = true
		if not button.visible and button.visible ~= nil then
			valid = false
		end

		if valid then
			love.graphics.setColor(buttonColor)
			if isHover(button,x,y) then
				love.graphics.draw(button.hoveredImage,button.x,button.y)
				if button.hovered ~= nil then
					button.hovered = true
				end 
				
			else
				love.graphics.draw(button.image,button.x,button.y)
				if button.hovered ~= nil then
					button.hovered = false
				end 
			end
		end
		
		if button.text ~= nil then
			local x = button.x + button.text.x or 0
			local y = button.y + button.text.y or 0
			local color = button.text.color or {1,1,1,1}
			if button.hovered then
				color = button.text.hoveredColor
			end
			love.graphics.setColor(color)
			love.graphics.printf(button.text.text,x,y,button.text.limit)
		end
	end
end



return buttons