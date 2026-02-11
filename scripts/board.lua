local board = {
	won = false,
	lost = false,
	cols = 10,
	rows = 10,
	mines = 0,
	width = 32,
	height = 32,
	tiles = {},
	offsetX = 640-330-15,
	offsetY = 15,
	lineWidth = 2,
	tileMargin = 1,
	flags = 0,
	clicks = 0,
	timer = 0,
	tileImages = {},
	disabledControls = false,
	firstClick = true,
	tileTypes = {
		[1] = {
			name = 'empty',
			amount = 0,
			probibility = 100,
			counted = false,
			clicked = function(self,tile) 
			
			end,
		},
		[2] = {
			name = 'mine', 
			amount = 12,
			probibility = 15,
			counted = true,
			clicked = function(self,tile)
				board:explodeMine()
			end
			},
		[3] = {
			name = 'treasure',
			amount = 0,
			probibility = 50,
			counted = false,
			clicked = function(self,tile)
				player:addGold(player.treasureYield)
				board[tile.type .. 's'] = board[tile.type .. 's'] - 1
			end,
			
		},
	},
}

--local functions

local function cursorCollision(obj,x,y)
	local x = x or 0
	local y = y or 0 
	return (cursorX >= obj.x+x) and (cursorX <= (obj.x+x + obj.width)) and 
		   (cursorY >= obj.y-y) and (cursorY <= (obj.y-y + obj.height))
end

--global board functions

function board:highlight(tile)
	if tile then
		if not tile.discovered then
			tile.highlighted = true
		end
	end
end

function board:unhighlight(tile)
	if tile then
		tile.highlighted = false
	end
end

function board:unhighlightBoard()
	for i, tile in pairs(self.tiles) do
		tile.highlighted = false
	end
end

function board:explodeMine(index) 
	board.lost = true
	board.disabledControls = true
end

function board:showBoard()
	for cols = 1, board.cols do
		for rows = 1, board.rows do
			board.tiles[cols .. ' ' .. rows].discovered = true
		end
	end
end

function board:calculateNeighbors(search)
	local search = search or 3
	--reset all tiles mineNeighbors to 0
	for i, tile in pairs(board.tiles) do
		tile.mineNeighbors = 0
		tile.treasureNeighbors = 0
	end
	--check all tiles in a i-pairs way
	for cols = 1, self.cols do
		for rows = 1, self.rows do
			local key = cols .. ' ' .. rows
			local tile = self:getTile(key)
			--local loop for a 3x3
			for i = 1, search do
				for j = 1, search do
					local valid = true
					local childCol,childRow = cols - 2 + i, rows - 2 + j 
					local childKey = childCol .. ' ' .. childRow
					local childTile = self:getTile(childKey)

					--break when its on its parent coordinates
					if childKey == key then
						valid = false
					end
					--make sure tile exists
					if childTile == nil then
						valid = false
					end
					
					if valid then
						-- if childTile.type == "mine" then
							-- tile.mineNeighbors = tile.mineNeighbors + 1									
						-- elseif childTile.type == 'treasure' then
							-- tile.treasureNeighbors = tile.treasureNeighbors + 1
						-- end
						
						for i, tileType in pairs(self.tileTypes) do
							if tileType.counted then
								if childTile.type == tileType.name then
									tile.mineNeighbors = tile.mineNeighbors + 1
								end
							end
						end
						
					end						
				end
			end
		end
	end
	
end

local function checkNearest(tile,recurseNum) 
	local rNum = recurseNum or 0
	local col,row = tile.col,tile.row
	local parentKey = col .. ' ' .. row
	
	--give a limit break on recursive search
	if rNum > 100 then
		print("Recursive Search reached to far: " .. rNum)
		return
	end
	
	--main loop for checking in a 3x3
	for i = 1, 3 do
		for j = 1, 3 do
			local valid = true
			-- child variables
			local childCol,childRow = col - 2 + i,row - 2 + j
			local childTile = board:getTile(childCol .. ' ' .. childRow)
			
			-- make sure tile is valid (edge cases)
			if childTile == nil then
				valid = false
			end
			
			--make sure tile is valid 
			if valid then
				if childTile.flagged then
					valid = false
				end
			end
			if valid then
				-- reveal one layer deep into the mine that give a number value.
				if childTile.type == 'empty' and childTile.mineNeighbors > 0 and rNum > 0 then
					if not childTile.discovered then
						board:discover(childTile)
					end
				end
				
				-- reveal current tile if it is empty and has 0 mineNeighbors than check the next tile.
				if childTile.type == 'empty' and childTile.mineNeighbors < 1 and not childTile.discovered then
					if not childTile.discovered then
						board:discover(childTile)
					end
					rNum = rNum + 1
					checkNearest(childTile,rNum)
				end
			end
		end
	end
end

function board:discover(tile) 
	--make sure tile isn't flagged or discovered
		if tile.flagged or tile.discovered then
			return
		end
	--set tile to discovered position
		tile.discovered = true
		
	--play an animation
		animator:play(tile,assetloader:getAnimation('tile_animation'),.05)
end

function board:safeClick(tile)
	self.firstClick = false
	--un-flag mine
	if tile.flagged then
		self.flags = board.flags - 1
		tile.flagged = false
	end
	--check mine type
	if tile.type == 'mine' then
		self.flags = board.flags + 1
		tile.flagged = true
	else
		board:discover(tile)
	end
	self:checkState()
end

function board:unsafeClick(tile)
	
	--check if tile is flagged
	if tile.flagged then
		return
	end
	
	if self.firstClick then
		if tile.type == 'mine' then
			board:teleport(tile)
		end
		self.firstClick = false
	end


	board:discover(tile)
	--add to click counter
	self.clicks = self.clicks + 1
	
	--activate function
	tile:clicked(tile)
end

function board:flag(tile)
	if tile.discovered then
		return
	end

	if not tile.flagged then
		self.flags = self.flags + 1
	else
		self.flags = self.flags - 1
	end
	tile.flagged = not tile.flagged
end

function board:teleport(tile)	
	tile.type = 'empty' 
	tile.clicked = self.tileTypes[1].clicked
	--find new tile to place tile
	for i, newTile in pairs(board.tiles) do
		if newTile.type == 'empty' and newTile ~= tile then
			for type in ipairs(self.tileTypes) do
				if type == tile.type then
					newTile.clicked = type.clicked
				end
			end
			newTile.type = tile.type
			return
		end
	end
end

function board:generateMines(step)
	local step = step or 0
	local random = 0
	
	for cols = 1, self.cols do
		for rows = 1, self.rows do
			local key = cols .. ' ' .. rows
			local tempTile = self.tiles[key]
			
			random = math.random(1,20) 
			
			if random == 1 and step < self.mines and tempTile.type == "empty" then
				tempTile.type = "mine"
				step = step + 1
			end
		end
	end
	
	--if the amount of mines is over the amount of empty spaces left then break loop.
	if step > (self.rows * self.cols) - 1 then
		self.mines = (self.rows * self.cols) - 1
		return 
	end
	
	--keep generating mines until it reaches the max amount of mines
	if step < self.mines then
		self:generateMines(step)
	else
		return
	end
end

function board:getTile(index) 
	if self.tiles[index] then
		return self.tiles[index]
	end
end

function board:checkState()
	local empty = 0
	for i, tile in pairs(self.tiles) do
		if tile.type ~= 'mine' and tile.discovered then
			empty = empty + 1
		end
	end
	
	if empty == (self.rows*self.cols)-self.mines then
		self.disabledControls = true
		self.won = true
	end
	return true
end

function board:getCollision()
	for i, tile in pairs(board.tiles) do
		if cursorCollision(tile) then
			return tile
		end
	end
	return nil
end

function board:generateTypes(type) 
	local amount = type.amount
	local name = type.name
	--reset amount if reset
	self[name .. 's'] = 0
	
	--recursion function
	local function recursiveGeneration(step)
		step = step or 0
		if step >= amount then
			return
		end
		for col = 1, self.rows do
			for row = 1, self.cols do
				local tile = self.tiles[col .. ' ' .. row]
				local random = math.random(1,100)
				if random <= type.probibility and tile.type == "empty" and step < amount then
					tile.type = name
					tile.clicked = type.clicked
					step = step + 1
					self[name .. 's'] = self[name .. 's'] + 1
				end
			end
		end
		recursiveGeneration(step)
	end
	if self[name .. 's'] < amount then
		recursiveGeneration()
	end
end

--for modding
function board:addTile(type,images,args,amount,counted)
	--set defaults
	local counted 	= counted or false
	local args 		= args or {clicked = function(self) end,hovered = function(self) end}
	local amount 	= amount or 10
	
	--load default images
	local images = images or {
		[1] = assetloader:getImage('tile'),
		[2] = assetloader:getImage('tile_empty'),
		[3] = assetloader:getImage('tile_mine'),
		[4] = assetloader:getImage('tile_flag'),
		[5] = assetloader:getImage('tile_hovered'),
		[6] = assetloader:getImage('tile_highlighted'),
	}
	--create new tile type doesn't exist
	if self.tileTypes[#self.tileTypes + 1] == nil then
		self.tileTypes[#self.tileTypes + 1] = {}
	--return if already exists
	else
		print("invalid tile type, preexisting type exists")
		return 
	end
	--import new tile type
	self.tileTypes[type] =	{
		name = type,
		amount = amount,
		probibility = 20,
		images = images,
		counted = counted,
		clicked = args.clicked,
		hovered = args.hovered,
	}
end

function board:reset(mines,treasures)
	--change seed by variation but maintaining consistency 
	math.randomseed(os.clock())
	
	--reset variables
	self.won = false
	self.lost = false
	disabledControls = false
	self.firstClick = true
	self.disabledControls = false
	self.timer = 0
	self.clicks = 0
	self.flags = 0
	
	--boards variables
	local mines = mines or 12
	local treasures = treasures or 0
	
	--set board variables
	self.treasures = 0
	self.mines = 0
	
	--set the mines that are counted to make them
	self.tileTypes[2].amount = mines
	self.tileTypes[3].amount = treasures
	
	--reset board to empty.
	self.tiles = {}
	
	--initialize the board.
	for cols = 1, self.rows do
		for rows = 1, self.cols do
			local key = cols .. ' ' .. rows
			self.tiles[key] = {
				x = ((cols-1) * (self.width  + self.tileMargin)) + self.offsetX,
				y = ((rows-1) * (self.height + self.tileMargin)) + self.offsetY,
				width = self.width,
				height = self.height,
				hovered = false,
				highlighted = false,
				discovered = false,
				type = "empty",
				col = cols,
				row = rows,
				mineNeighbors = 0,
				treasureNeighbors = 0,
				flagged = false,
				images = self.tileImages,
				clicked = function(self,tile) checkNearest(tile) end,
				animationPlaying = false,
			}
			
		end
	end
	
	--generate mines and custom tiles
	for i, instance in ipairs(self.tileTypes) do
		if instance.name ~= 'empty' then
			self:generateTypes(instance)
		end
	end
	
	-- self:generateMines()
	self:calculateNeighbors()
end


function board:load()
	self.tileImages = {
		[1] = assetloader:getImage('tile'),
		[2] = assetloader:getImage('tile_empty'),
		[3] = assetloader:getImage('tile_mine'),
		[4] = assetloader:getImage('tile_flag'),
		[5] = assetloader:getImage('tile_hovered'),
		[6] = assetloader:getImage('tile_highlighted'),
	}
	--add tiles
	-- board:addTile('test',nil,{
	-- clicked = function() 
		
	-- end,
	-- hovered = function() 
	
	-- end
	-- },0)
end

function board:update(dt,canvasX,canvasY)
	--timer
	if not self.firstClick then
		self.timer = self.timer + dt
	end
	
	--clicking mines function
	if not self.disabledControls then
		for i, tile in pairs(self.tiles) do
			if cursorCollision(tile,canvasX,canvasY) then
				tile.hovered = true
				if leftClick and not tile.discovered and not draggable then
					self:calculateNeighbors()
					self:unsafeClick(tile)
					self:checkState()
				--for putting flags
				elseif rightClick then
					self:flag(tile)
					self:checkState()
				end
			else
				--if not in collision set tile to not hovered.
				tile.hovered = false
			end
		end
	end
end

function board:draw()

	--draw the tiles
	for i, tile in pairs(self.tiles) do
		
		
		
		local frame = 1
		
		if tile.hovered then
			frame = 5
		end
		
		if tile.discovered then
			if tile.type == 'empty' or 'treasure' then
				frame = 2
			elseif tile.type == 'mine' then
				frame = 3
			end
			
		end
		if tile.flagged then
				frame = 4
		end
		if tile.highlighted then
			frame = 6
		end
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(tile.images[frame],tile.x,tile.y)
	
		-- shows the nearby neighbor texts
		local offsetX = 12
		local offsetY = 9
		if tile.mineNeighbors > 0 and tile.discovered and tile.type ~= 'mine' then
			love.graphics.setColor(0,0,1,1) 
			love.graphics.setFont(perfect_dos_16)
			love.graphics.print(tile.mineNeighbors,tile.x + offsetX,tile.y + offsetY)
		end
		
		animator:draw(tile)
		
	end
end




return board