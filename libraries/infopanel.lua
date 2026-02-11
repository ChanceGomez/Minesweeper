local infopanel = {
	image = nil
}

function infopanel:load()
	self.image = assetloader:getImage('info_panel')
end

function infopanel:draw(obj)
	local x,y = cursorX + 16,cursorY
	local text = obj.description
	
	if text == nil then
		return
	end
	if not obj.hovered then
		return
	end
	--figure out of panel would go over the border
	if y > HEIGHT - self.image:getHeight() then
		y = HEIGHT - self.image:getHeight()
	end

	if x > WIDTH - self.image:getWidth() then
		x = WIDTH - self.image:getWidth()

	end
	
	
	
	--draw panel and text
	love.graphics.draw(self.image,x,y)
	love.graphics.setFont(perfect_dos_16)
	love.graphics.setColor(0,0,0,1)
	love.graphics.printf(text,x+8,y+8,self.image:getWidth()-8)
end




return infopanel