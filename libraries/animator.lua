local animator = {
	animations = {}
}

function animator:play(obj,frames,time)
	--make sure an animation is not playing
	for i, animation in ipairs(self.animations) do
		if animation.obj == obj then
			return
		end
	end
	--make sure there is a valid frames 
	if frames == nil then return end
	-- get local variables
	local time 		= time or 1
	local size 		= #frames or 0
	
	--make sure their are more than 0 frames
	if size == 0 then return end
	
	--set objects animation boolean to true
	if obj.animationPlaying ~= nil then
		obj.animationPlaying = true
	end
	
	--insert the animation into self.animations
	table.insert(self.animations,{
		timer 		= 0,
		obj 		= obj,
		frames 		= frames,
		frameTime 	= time,
		frame 		= 1,
	})
end

function animator:isPlaying(obj)
	for i, animation in ipairs(self.animations) do
		if animation.obj == obj then
			return true
		end
	end
	return false
end

function animator:update(dt)
	for i, animation in ipairs(self.animations) do
		animation.timer = animation.timer + dt
		if animation.timer > animation.frameTime then
			animation.timer = 0
			animation.frame = animation.frame + 1
		end
		if animation.frame > #animation.frames then
			table.remove(self.animations,i)
			animation.obj.animationPlaying = false
			return
		end
	end	
end

function animator:draw(obj)
	for i, animation in ipairs(self.animations) do
		if animation.obj == obj then
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(animation.frames[animation.frame],obj.x,obj.y)
		end
	end
end

return animator 