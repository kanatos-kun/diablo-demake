dt = 1/60
t=0
x_map=52
y_map=16

x2=0
y2=0

SCALE = 2
TILE_WIDTH_HALF = 8
TILE_HEIGHT_HALF = 4
camera = {x=0,y=0}
map={
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0},
	{0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0},
	{0,0,1,1,0,1,0,0,1,1,0,1,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{1,1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0},
	{0,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0},
	{0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
	{0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
	{0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},
	{0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},

}
Sprites = {}
hero = {}
helping_box={
	row=0,
	col=0
}
path_already_loaded = false
path_already_loaded_counter = 0
path_tile={}
path_tile_reverse={}


function creerSprite(index,col,row,pAlpha,xOffset,yOffset,tag)

-- @i             index du sprite utilise
-- @row           position x du sprite(en ligne)
-- @col           position y du sprite(en colonne)
-- [@pAlpha]      Couleur alpha utilise
-- [@xOffset]     Position de decalage x
-- [@yOffset]     Position de decalage y
-- [@tag]         tag du sprite
 local sprite = {}

sprite.i = index
sprite.row = row
sprite.col = col
sprite.x = (8*col-8*row) * SCALE
sprite.y = (4*col+4*row) * SCALE
sprite.pathTrackObject = {}
sprite.pathFindingIsOn = false
sprite.moveVitesse = 2
sprite.moveVitesseCounter = 0
sprite.pointSquareDestination = {}
sprite.distanceSquareDestination = {x=0,y=0}
sprite.pointDistanceStep = {x=0,y=0}
sprite.followPath = function()


	if(sprite.pathFindingIsOn == true) then
		sprite.moveVitesseCounter = sprite.moveVitesseCounter + dt
		if(#sprite.pathTrackObject <=2) then
		sprite.pointDistanceStep.x = 0
		sprite.pointDistanceStep.y = 0
		end
		if(sprite.pointSquareDestination ~= nil and
		   #sprite.pathTrackObject > 1) then
			   -- trace("lenght object : ".. #sprite.pathTrackObject)
			if(sprite.pathTrackObject[#sprite.pathTrackObject - 1].col ~=  sprite.pointSquareDestination.col or
		 	   sprite.pathTrackObject[#sprite.pathTrackObject - 1].row ~=  sprite.pointSquareDestination.row) then
				   sprite.pointSquareDestination = sprite.pathTrackObject[#sprite.pathTrackObject - 1]
				   local point_dest = {
				  x = (8*sprite.pointSquareDestination.col-8*sprite.pointSquareDestination.row),
				  y = (4*sprite.pointSquareDestination.col+4*sprite.pointSquareDestination.row)
			  	  }--mapToScreen(sprite.pointSquareDestination.row ,sprite.pointSquareDestination.col)
				   -- trace("x_dest: "..point_dest.x)
				   -- trace("y_dest: "..point_dest.y)
				   -- trace("x_sprite: "..sprite.x)
				   -- trace("y_sprite: "..sprite.y)
				   -- trace("col_dest: "..sprite.pointSquareDestination.col)
				   -- trace("row_dest: "..sprite.pointSquareDestination.row)
				   -- trace("col_sprite: "..sprite.col)
				   -- trace("row_sprite: "..sprite.row)
				   sprite.pointDistanceStep=calculDistance({x=sprite.x,y=sprite.y} ,point_dest)

					   sprite.pointDistanceStep.x = sprite.pointDistanceStep.x *( dt * 4)
					   sprite.pointDistanceStep.y = sprite.pointDistanceStep.y *( dt * 4)




			   end
		end

		if(sprite.moveVitesseCounter >= 1/4)then
			table.remove(sprite.pathTrackObject,#sprite.pathTrackObject)
			local a = sprite.pathTrackObject[#sprite.pathTrackObject]
			sprite.col = a.col
			sprite.row = a.row
			sprite.moveVitesseCounter = 0
			sprite.distanceSquareDestination = {x=0,y=0}
			if(#sprite.pathTrackObject == 1) then
			     sprite.pathFindingIsOn = false
			     path_tile_reverse = {}
			     path_tile = {}
			     sprite.pointDistanceStep = {x=0,y=0}
			end
		end

	end

end

if pAlpha == nil then
   sprite.pAlpha = 0

else
  sprite.pAlpha = pAlpha
end

if xOffset == nil then
   sprite.x_offset = 8
else
  sprite.x_offset = xOffset
end

if yOffset == nil then
   sprite.y_offset = -8
else
  sprite.y_offset = yOffset
end


table.insert(Sprites,sprite)
hero = sprite
return sprite
end


function calculDistance(depart ,destination)
local a = {}
a.x =  destination.x - depart.x
a.y =  destination.y - depart.y
return a;
end


function AStarPathfinding(point, sprite)

	point.x = point.x +1
	point.y = point.y +1

	sprite.pathFindingIsOn = false
	path_tile = {}
	path_tile_reverse = {}

	-- check for error field
	if(map[point.y]== nil )then
		return false;
	elseif(map[point.y][point.x]== nil) then
		return false;
	elseif(map[point.y][point.x]== 1) then
		return false;
            end

	start_square = {
		col = sprite.col,
		row = sprite.row,
		score_F = 0,
		score_H = 0,
		score_G = 0,
		dir = 0,
		parent = "root"
	}
	openList= {}
	closedList = {}
	local current_square = addSquareForAStarPathfinding(start_square,point,0)

	table.insert(path_tile,current_square)
	table.insert(closedList,current_square)
	local term_secur = 50
	local stopBoucle = true
	if((current_square.col == point.x) and (current_square.row == point.y) ) then
		 stopBoucle = false
	end
	while( stopBoucle ) do
		-- trace("point.x : "..point.x)
		-- trace("current_square.col : "..current_square.col)
		-- trace("point.y : "..point.y)
		-- trace("current_square.col : "..current_square.row)
		-- Securite au cas ou la boucle est infinie :o
		term_secur = term_secur -1
		if(term_secur <= 0) then
			 term_secur = 0
			 sprite.pathFindingIsOn = false
			  break
		  end

		-- ------------------------------------------------
		-- [algorithm a*]


		local square_right = addSquareForAStarPathfinding(current_square,point,1)
		local square_left = addSquareForAStarPathfinding(current_square,point,2)
		local square_top = addSquareForAStarPathfinding(current_square,point,3)
		local square_bottom = addSquareForAStarPathfinding(current_square,point,4)


		-- Recherche si un noeud courant est dejà dans la liste ouverte
		for i,v in ipairs(openList) do
			if       (v.row == square_right.row and v.col == square_right.col) then
				square_right.isInOpenList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_left.row and v.col == square_left.col) then
				square_left.isInOpenList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_bottom.row and v.col == square_bottom.col) then
				square_bottom.isInOpenList = true
			            --Deja dans la liste ouverte
			elseif   (v.row == square_top.row and v.col == square_top.col) then
				square_top.isInOpenList = true
				--Deja dans la liste ouverte
			end
		end

		-- Recherche si un noeud courant est dejà dans la liste ouverte
		for i,v in ipairs(closedList) do
			if       (v.row == square_right.row and v.col == square_right.col) then
				square_right.isInClosedList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_left.row and v.col == square_left.col) then
				square_left.isInClosedList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_bottom.row and v.col == square_bottom.col) then
				square_bottom.isInClosedList = true
			            --Deja dans la liste ouverte
			elseif   (v.row == square_top.row and v.col == square_top.col) then
				square_top.isInClosedList = true
				--Deja dans la liste ouverte
			end
		end


		-- dir help
		-- 0 = center
		-- 1 = droite
		-- 2 = gauche
		-- 3 = haut
		-- 4 = bas


		if(square_right.isInOpenList ~= true and square_right.isInClosedList ~= true and square_right.isInNonWalkableTile ~= true) then table.insert(openList,square_right)
		end
		if(square_left.isInOpenList ~= true and square_left.isInClosedList ~= true and square_left.isInNonWalkableTile ~= true)then table.insert(openList,square_left) end
		if(square_top.isInOpenList ~= true and square_top.isInClosedList ~= true and square_top.isInNonWalkableTile ~= true)then table.insert(openList,square_top) end
		if(square_bottom.isInOpenList ~= true and square_bottom.isInClosedList ~= true and square_bottom.isInNonWalkableTile ~= true)then table.insert(openList,square_bottom) end



	          --Recherche de la valeur la plus basse de F dans la liste ouverte
	          local temp_min = openList[1].score_F
	          	          for i = 1,#openList do
			          local val1 =openList[i].score_F
			           for j = 1,#openList do
				          local val2 = openList[j].score_F
		 		          if(val2 <= val1) then
					   if(temp_min >= val1) then
		 			       temp_min = val2
					   end
		 		          end
			           end

		          end



	          for i = #openList,1,-1 do
		    local cSquare = openList[i]
		    if(temp_min == cSquare.score_F)  then
			    table.insert(closedList,cSquare)
			    table.insert(path_tile,cSquare)
			    current_square = cSquare
			    for i,v in ipairs(openList) do
				 if(cSquare.col == v.col and
			 	    cSquare.row == v.row) then
				     table.remove(openList,i)
				     break
			             end
			    end
			    break
		    end
	          end



		-- ------------------------------------------------
		-- [/algorithm a*]
		if((current_square.col == point.x) and (current_square.row == point.y) ) then
            		stopBoucle = false
		          trackPath(current_square, sprite.pathTrackObject)
	          	          sprite.pathFindingIsOn = true
	            end
	end

end

function trackPath(pSquare, pathTrackObject)
	local bool = true
	local subSquare = pSquare
	local iter_secur = 50
	table.insert(path_tile_reverse,pSquare)
	table.insert(pathTrackObject,pSquare)
	while( bool) do
		iter_secur = iter_secur -1
		if(iter_secur <= 0) then break end
		local parent = subSquare.parent
		if(parent == "root") then
		return path
		else
		table.insert(path_tile_reverse,subSquare)
		table.insert(pathTrackObject,subSquare)
		subSquare = parent
	 	end

	end

end

function addSquareForAStarPathfinding(pSquare,point,dir)
	local square = {}
	if(dir == 0) then
	square.col=pSquare.col
	square.row=pSquare.row
	elseif(dir == 1) then
	square.col=pSquare.col + 1
	square.row=pSquare.row
	elseif(dir == 2) then
	square.col=pSquare.col - 1
	square.row=pSquare.row
	elseif(dir == 3) then
	square.col=pSquare.col
	square.row=pSquare.row - 1
	elseif(dir == 4) then
	square.col=pSquare.col
	square.row=pSquare.row + 1
	end
	square.score_G=pSquare.score_G + 1
	square.score_H=math.max(square.col,point.x) - math.min(square.col,point.x)  +
		   math.max(square.row,point.y) - math.min(square.row,point.y)
	square.score_F=square.score_G + square.score_H
	square.dir=dir
	square.parent = pSquare
	square.isInOpenList = false
	square.isInClosedList = false
	square.isInNonWalkableTile = false
	if(map[square.row] ~= nil) then
	local tileType = map[square.row][square.col];
		if(tileType ~= nil) then
			if(tileType == 1) then
			 square.isInNonWalkableTile = true
			end
		end
	end

	if(map[square.row] == nil) then
	    square.isInNonWalkableTile = true
    	elseif(map[square.row][square.col] == nil) then
	    square.isInNonWalkableTile = true
	end

	return square
end

function init()
	hero =creerSprite(12,1,1,11,nil,nil)
	hero.tag = "hero"
end


init()
function TIC()
	-- local test = mapToScreen(hero.row,hero.col)
	x_map =52 -hero.x
	y_map = 16 -hero.y
	mx,my,md = mouse()
	x2=mx
	y2=my
	local point = screenToMap(mx, my)
	if (md == true and path_already_loaded == false) then
		path_already_loaded = true
		helping_box.col = point.x
		helping_box.row = point.y
		-- define the pathFinding for the player
		hero.pathTrackObject = {}
		AStarPathfinding( point ,hero);
		-- set the movment into motion for the player

	end

	if (path_already_loaded == true) then
		path_already_loaded_counter = path_already_loaded_counter + 1
		if path_already_loaded_counter == 20 then
			path_already_loaded_counter = 0
			path_already_loaded = false
		end
	end

	hero.followPath()
	poke(0x3FFB,8)
	local x=Sprites[1].col
	local y =Sprites[1].row
	-- if btnp(0) then
	-- 	if y-1 >= 1 then
	--             y=y-1
	--  	end
	--  end
	-- if btnp(1) then
	-- 	if y+1 <= #map then
	-- 	y=y+1
	--  	end
	--  end
	-- if btnp(2) then
	-- 	if x-1 >= 1 then
	-- 	x=x-1
	-- 	end
	-- end
	-- if btnp(3) then
	-- 	if x+1 <=#map[y] then
	-- 	x=x+1
	-- 	end
	-- end
	Sprites[1].col = x
	Sprites[1].row = y
	cls(2)
	draw()
	t=t+dt



end


function draw()

	for row=1,#map do
		for col=1,#map[row] do
			-- @col : index colonne
			-- @row : index ligne
			if(map[row][col] == 0) then
			   setTile(1,row,col,0)
		   	elseif(map[row][col] == 1) then
			   setTile(10,row,col,5)
			end

		end
	end

	for i,v in ipairs(path_tile) do
	     setTile(16,v.row,v.col,0)
	end

	for i,v in ipairs(path_tile_reverse) do
	     setTile(4,v.row,v.col,0)
	end

	drawSprite()
	draw_helping_box()
end

function drawSprite()
	for i_spr=1,#Sprites do
		local sprite = Sprites[i_spr]
		local i = sprite.i
		local row = sprite.row
		local col = sprite.col
		local x_offset= sprite.x_offset
		local y_offset = sprite.y_offset
		sprite.distanceSquareDestination.x = sprite.distanceSquareDestination.x + sprite.pointDistanceStep.x
		sprite.distanceSquareDestination.y = sprite.distanceSquareDestination.y + sprite.pointDistanceStep.y
		sprite.x = (8*col-8*row) + sprite.distanceSquareDestination.x
		sprite.y = (4*col+4*row) + sprite.distanceSquareDestination.y

		local pAlpha = sprite.pAlpha
		spr(i, (x_map+ sprite.x )* SCALE + x_offset,( y_map+sprite.y ) * SCALE + y_offset,pAlpha,SCALE)
		-- spr(i, (x_map+8*col-8*row )* SCALE + x_offset,(y_map+4*col+4*row) * SCALE + y_offset,pAlpha,SCALE)

	end

end


function draw_helping_box()
	--spr(15, (x_map+8*col-8*row )* SCALE + x_offset,(y_map+4*col+4*row) * SCALE + y_offset,pAlpha,SCALE)
	--bottom square
	local x = (x_map+8*(helping_box.col +1)-8*(helping_box.row +1) )* SCALE + (8*SCALE) -1
	local y = (y_map+4*(helping_box.col +1)+4*(helping_box.row +1) ) * SCALE -1
	line(x,y,x + (TILE_WIDTH_HALF*SCALE),y + (TILE_HEIGHT_HALF*SCALE),14)
	line(x-(TILE_WIDTH_HALF*SCALE),y+(TILE_HEIGHT_HALF*SCALE),x,y + (TILE_WIDTH_HALF*SCALE),14)
	line(x-(TILE_WIDTH_HALF*SCALE),y+(TILE_HEIGHT_HALF*SCALE),x,y,14)
	line(x,y+(TILE_WIDTH_HALF*SCALE),x + (TILE_WIDTH_HALF*SCALE),y + (TILE_HEIGHT_HALF*SCALE),14)
end

function setTile(pType,row,col,pAlpha)
	-- @pType         index type tile
	-- @row           position y de la tile(en ligne)
	-- @col           position x de la tile(en colonne)
	-- [@pAlpha]      index alpha color

	if pAlpha == nil then
	   pAlpha = 0
   	end
	local point =  mapToScreen(row,col)
	spr(pType, point.x, point.y ,pAlpha,SCALE)
	spr(pType, point.x + TILE_WIDTH_HALF
	*SCALE, point.y ,pAlpha,SCALE,1)
end

function mapToScreen(row, col)
	local point = { x=0,y=0}
	point.x = (x_map + ( col - row ) * TILE_WIDTH_HALF ) * SCALE
	point.y = (y_map +( col + row) * TILE_HEIGHT_HALF ) * SCALE
	return point
end

function screenToMap(mx, my)
	local point = {}
	point.x = math.floor( ( (mx-x_map *SCALE)/(TILE_WIDTH_HALF) +(my-y_map *SCALE)/TILE_HEIGHT_HALF ) /(2*SCALE)  ) -1
	point.y = math.floor( ( (my-y_map *SCALE)/(TILE_HEIGHT_HALF) -(mx-x_map*SCALE)/TILE_WIDTH_HALF ) /(2*SCALE)  )
	return point
end

function OVR()
	rect(0,94,241,42,3)
	line(0,93,241,93,0)
	circ(64,97,17,6)
	circb(64,97,17,16)
	circ(182,97,17,8)
	circb(182,97,17,16)
	local diable_spr = {
		{176,177,178,179,180,181,182},
		{192,193,194,195,196,197,198},
		{208,209,210,211,212,213,214},
		{224,225,226,227,228,229,230},
		{240,241,242,243,244,245,246},
		{256,257,258,259,260,261,262},
	}

	local angel_spr = {
		{272,273,274,275,276},
		{288,289,290,291,292},
		{304,305,306,307,308},
		{320,321,322,323,324},
		{336,337,338,339,340}
	}

	for y=1,#diable_spr do
		for x=1,#diable_spr[y] do
			spr(diable_spr[y][x],30 + x*8,86 + y*8,5)
		end
	end

	for y=1,#angel_spr do
		for x=1,#angel_spr[y] do
			spr(angel_spr[y][x],155 + x*8,88 + y*8,5)
		end
	end

	spr(100,x2,y2,5,SCALE);
end
