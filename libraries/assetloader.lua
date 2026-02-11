--[[
	programmer: Chance Gomez | chance.f.gomez@gmail.com
	file: 		assetloader.lua
	purpose:	load assets from given path string when loaded and load all png/jpg/jpeg files 
				using assetloader:getImage('name of file') it will return the image data.
]]

local assetloader = {
	images = {},
	animations = {},
	fonts = {},
}

function assetloader:getImage(name)
	--try catch
	if self.images[name] then	
		return self.images[name]
	else
		print(name.. " not found settings default")
		if self.images['default'] then
			return self.images['default']
		else
			print("No Default Image loaded")
		end	
	end
end

function assetloader:getAnimation(name)
	if self.animations[name] then
		return self.animations[name]
	else
		print(name .. " Animation not found")
		return
	end
end

function assetloader:getFont(name)

end

function assetloader:loadDirectory(filepath)
	--table to return
	local tbl = {}
	
	local assetTable = love.filesystem.getDirectoryItems(filepath)
	
	for i, asset in ipairs(assetTable) do
	
		local assetsPath = filepath .. '/' .. asset
		local validityCheck = love.filesystem.getInfo(assetsPath)
		
		
		if validityCheck.type == 'file' then
			--get the name and extension of file	
			local name, number, extension = asset:match("^(.-)_(%d+)(%.%w+)$")
			
			if extension == '.png' or extension == '.jpg' or extension == '.jpeg' then
				--get the base name before modifications
				local basename = name
				
				--insert new image into table
				tbl[tonumber(number)] = love.graphics.newImage(assetsPath)
				
				--load into default images table
				if not self.images[basename] then
					self.images[basename .. '_' .. number] = {}
				end
				print(i .. ': ' .. basename .. '_' .. number .. ' | loaded')
				self.images[basename .. '_' .. number] = love.graphics.newImage(assetsPath)
				
			end
		end
	end
	--return table
	return tbl
end	

function assetloader:loadImages(filepath)
	local assetTable = love.filesystem.getDirectoryItems(filepath)
	
	for i, asset in ipairs(assetTable) do
		--create full path to asset
		local assetsPath = filepath .. '/' .. asset
		
		local validityCheck = love.filesystem.getInfo(assetsPath)
		
		
		if validityCheck then	
			--make sure its a file and not a directory
			if validityCheck.type == 'file' then
				--get the name and extension of file	
				local name, extension = asset:match("([^.]+)(%.?.*)")
				
				if extension == '.png' or extension == '.jpg' or extension == '.jpeg' then
					local basename = name
					if not self.images[basename] then
						self.images[basename] = {}
					end
					print(i .. ': ' .. basename .. ' | loaded')
					self.images[basename] = love.graphics.newImage(assetsPath)
					
				end
			end
		end
	end
end

function assetloader:loadAnimations(filepath)
	local assetTable = love.filesystem.getDirectoryItems(filepath)
	
	for i, asset in ipairs(assetTable) do
		--create full path to asset
		local assetsPath = filepath .. '/' .. asset
		
		local validityCheck = love.filesystem.getInfo(assetsPath)
		
		
		if validityCheck then	
			--make sure its a directory.
			if validityCheck.type == 'directory' then
				--get name of animation from folders name
				local name = asset:match("([^.]+)")
				--make sure it doesn't already exist.
				if not self.animations[name] then
					self.animations[name] = {}
				end
				--create new file path
				local newFilepath = filepath .. '/' .. name
				self.animations[name] = assetloader:loadDirectory(newFilepath)
			end
		end
	end
end

function assetloader:loadFonts(filepath) 
	local assetTable = love.filesystem.getDirectoryItems(filepath)
	
	
	
end
 
return assetloader