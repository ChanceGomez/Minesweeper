local textfields = {
	fields = {}
}

local function collision(obj)
	local x,y = love.mouse.getPosition()
	return x > obj.x and x < obj.x + obj.width and
		   y > obj.y and y < obj.y + obj.height
end

function textfields:create(name,x,y,width,height,var,backgroundColor,textColor)
	local x = x or 0
	local y = y or 0
	local width = width or 200
	local height = height or 50
	local backgroundColor = backgroundColor or {1,1,1,1}
	local textColor = textColor or {0,0,0,1}
	
	local type = type(var)
	
	
	self.fields[name] = {
		type = type,
		x = x,
		y = y,
		width = width,
		height = height,
		backgroundColor = backgroundColor,
		textColor = textColor,
		selected = false,
		formattedString = tostring(var),
		timer = 0,
		var = var,
	}
	
end

function textfields:update(dt)
	for i, field in pairs(self.fields) do
		local formatted = tostring(field.var) .. '|'
		if collision(field) and love.mouse.isDown(1) then
			field.selected = true
			field.formattedString = formatted
			for j, deselect in pairs(self.fields) do
				if deselect ~= field then
					deselect.selected = false
					deselect.formattedString = tostring(var)
				end	
			end
		end

		--timer
			if field.selected then
				field.timer = field.timer + dt
			else
				field.timer = 0
			end
			
			if field.timer > .8 then
				field.formattedString = tostring(field.var)
				field.timer = 0
			elseif field.timer < .5 and field.timer > .1 and field.selected then
				field.formattedString = formatted
			end
		--add key press
			if field.selected and controls.keyboardClicked then
				print(field.var)
				field.var = field.var .. controls.keyboard_lastClicked
			end
		
	end
end

function textfields:draw_field(name)
	local obj = self.fields[name]
	
	--background
	love.graphics.setColor(obj.backgroundColor)
	love.graphics.rectangle("fill",obj.x,obj.y,obj.width,obj.height)
	
	--print
	love.graphics.setColor(obj.textColor)
	love.graphics.print(tostring(obj.formattedString),obj.x,obj.y)
	
end

















return textfields