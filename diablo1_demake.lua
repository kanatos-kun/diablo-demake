-- Help function:
-- [*init]
-- [*tic]
-- [*creerSprite]
-- [*creerUIButton]
-- [*creerUIPanel]
-- [*creerUIText]
-- [*creerCharacterData]
-- [*calculDistance]
-- [*AStarPathfinding]
-- [*trackPath]
-- [*addSquareForAStarPathfinding]
-- [*draw]
-- [*drawSprite]
-- [*draw_helping_box]
-- [*setTile]
-- [*mapToScreen]
-- [*screenToMap]
-- [*OVR]
-- [*switchPal]
--[*changeUIbuttonState]
sync(0,0,false)
dt = 1/60
t=0
x_map=52
y_map=16

x2=0
y2=0

SCALE = 2
TILE_WIDTH_HALF = 8
TILE_HEIGHT_HALF = 4
-- camera = {x=0,y=0}
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
UI = {
	baseMenu= { button={},panel={},text={} },
	char={ button={},panel={},text={}  },
	["char/1"]={ button={},panel={},text={}  },
	menu={ button={},panel={},text={}  },
	inv={ button={},panel={},text={}  },
	spells={ button={},panel={},text={}  },
	quest={ button={},panel={},text={}  },
	currentState = ""
	-- BASE_MENU
	-- CHAR
	-- MAP
	-- MENU
	-- SPELL
	-- QUEST
	-- INV
}
hero = {}
helping_box={
	row=0,
	col=0
}
path_already_loaded = false
path_already_loaded_counter = 0
button_click_already = false
button_click_already_counter = 0
path_tile={}
path_tile_reverse={}
character ={
	--[1]
	-- priest
	{
		color ={
			skin = 12,
			shirt = 15,
			pant = 15
		}
	},
	--[2]
	-- demon
	{
		color ={
			skin = 6,
			shirt = 6,
			pant = 6
		}
	},
	--[3]
	-- goblin
	{
		color ={
			skin = 11,
			shirt = 11,
			pant = 4,
			alpha = 2
		}
	},
	--[4]
	-- witch
	{
		color ={
			skin = 15,
			shirt = 1,
			pant = 1
		}
	},
	--[5]
	-- blacksmith
	{
		color ={
			skin = 12,
			shirt = 4,
			pant = 3
		}
	},
	--[6]
	-- drunkyard
	{
		color ={
			skin = 12,
			shirt = 5,
			pant = 4
		}
	},
	--[7]
	-- blue man
	{
		color ={
			skin = 12,
			shirt = 2,
			pant = 3
		}
	},
	--[8]
	-- knight
	{
		color ={
			skin = 12,
			shirt = 7,
			pant = 3
		}
	},
	--[9]
	-- girl with yellow robe
	{
		color ={
			skin = 12,
			shirt = 14,
			pant = 14
		}
	},
	--[10]
	-- hero
	{
		color ={
			skin = 12,
			shirt = 4,
			pant = 6
		},
		data = {
			name = "Jojoffrey",
			class="warrior",
			lvl = 1,
			hp = 50,
			current_hp = 50,
			mana = 20,
			current_mana = 20,
			strength = 10,
			magic = 10,
			dexterity = 10,
			vitality = 10,
			hp_bonus = 0,
			mana_bonus = 0,
			strength_bonus = 0,
			magic_bonus = 0,
			dexterity_bonus = 0,
			vitality_bonus = 0,
			gold = 0,
			armor_class = 0,
			hit = 1,
			damage = 0,
			resistMagic = 0,
			resistFire = 0,
			resistLightning = 0,
			currentExp = 0,
			nextLevel = 300,
			statsPoint = 0
		}
	},

}

-- [*creerSprite]
function creerSprite(index,col,row,pAlpha,xOffset,yOffset,tag,pColor)

-- @i             index du sprite utilise
-- @row           position x du sprite(en ligne)
-- @col           position y du sprite(en colonne)
-- [@pAlpha]      Couleur alpha utilise
-- [@xOffset]     Position de decalage x
-- [@yOffset]     Position de decalage y
-- [@tag]         tag du sprite
-- [@pColor]       color custom du sprite

 local sprite = {}
sprite.i = index
sprite.timeFrame = 0
sprite.currentFrame=1
sprite.currentAnimation = "idle"
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

if(pColor ~= nil) then
sprite.color = {
	skin = pColor.skin,
	shirt = pColor.shirt,
	pant = pColor.pant,
	alpha = pColor.alpha
}
end

sprite.followPath = function()


	if(sprite.pathFindingIsOn == true) then
		sprite.moveVitesseCounter = sprite.moveVitesseCounter + dt
		if(#sprite.pathTrackObject <=2) then
		sprite.pointDistanceStep.x = 0
		sprite.pointDistanceStep.y = 0
		end
		if(sprite.pointSquareDestination ~= nil and
		   #sprite.pathTrackObject > 1) then
			if(sprite.pathTrackObject[#sprite.pathTrackObject - 1].col ~=  sprite.pointSquareDestination.col or
		 	   sprite.pathTrackObject[#sprite.pathTrackObject - 1].row ~=  sprite.pointSquareDestination.row) then
				   sprite.pointSquareDestination = sprite.pathTrackObject[#sprite.pathTrackObject - 1]
				   local point_dest = {
				  x = (8*sprite.pointSquareDestination.col-8*sprite.pointSquareDestination.row),
				  y = (4*sprite.pointSquareDestination.col+4*sprite.pointSquareDestination.row)
			  	  }
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
	else
		sprite.currentAnimation = "idle"
	end
end
sprite.animation = {

	moveAnimation = {
		idle={12},
		move={13,14}
	},
	setMotion = function()
		local a = sprite.animation.moveAnimation[sprite.currentAnimation]
		sprite.timeFrame = sprite.timeFrame + dt

		if(sprite.timeFrame >= 0.35) then
			if((sprite.currentFrame+1) <= #a  ) then
				sprite.currentFrame = sprite.currentFrame +1
				sprite.i = a[sprite.currentFrame]
				sprite.timeFrame = 0
			else
				sprite.timeFrame = 0
				sprite.currentFrame = 1
				sprite.i = a[sprite.currentFrame]
			end
		end
	end
}
sprite.direction = "right"
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
sprite.data = creerCharacterData(character[10].data,tag)

table.insert(Sprites,sprite)
return sprite
end
--[*creerCharacterData]
function creerCharacterData(obj,tag)
local data = {}

if(tag =="hero") then
data.name = obj.name
data.class = obj.class
data.lvl = obj.lvl
data.hp = obj.hp
data.hp_bonus = obj.hp_bonus
data.current_hp = obj.current_hp

data.mana = obj.mana
data.mana_bonus = obj.mana_bonus
data.current_mana = obj.current_mana

data.strength = obj.strength
data.strength_bonus = obj.strength_bonus

data.magic = obj.magic
data.magic_bonus = obj.magic_bonus

data.dexterity = obj.dexterity
data.dexterity_bonus = obj.dexterity_bonus

data.vitality = obj.vitality
data.vitality_bonus = obj.vitality_bonus

data.gold = obj.gold
data.armor_class = obj.armor_class
data.hit = obj.hit
data.damage = obj.damage
data.resistMagic =obj.resistMagic
data.resistFire = obj.resistFire
data.resistLightning = obj.resistLightning
data.currentExp = obj.currentExp
data.nextLevel = obj.nextLevel
data.statsPoint = obj.statsPoint
end

return data;
end


-- [*creerUIButton]
function creerUIButton(x,y,width,height,color,text,context)
-- @x                  position x du rectangle
-- @y                  position y du rectangle
-- @width              largeur du rectangle
-- @height             hauteur du rectangle
-- @color(table)       couleur du rectangle (colorbutton = 1;colorbuttonHover = 2;colorText = 3;colorTextHover = 4)
-- [@text]             texte du button
-- @context            le context de l'UI


local button = {}
button.x = x
button.y = y
button.width = width
button.height = height
button.color = color[1]
button.colorHover = color[2]
button.colorText = color[3]
button.colorTextHover = color[4]
button.text =""
button.visible = false
button.context = context
if(button.text ~= nil) then
button.text = text
end
table.insert(UI[context].button,button)
return button
end

--[*changeUIbuttonState]
function changeUIbuttonState(state)
	if(UI.currentState ~= state) then
	UI.currentState = state
	else
	UI.currentState = "BASE_MENU"
	end
end

-- [*creerUIPanel]
function creerUIPanel(x,y,width,height,color,context)
-- @x           position x du rectangle
-- @y           position y du rectangle
-- @width       largeur du rectangle
-- @height      hauteur du rectangle
-- @color       couleur du rectangle
-- @context     le context de l'UI


local panel = {}
panel.x = x
panel.y = y
panel.width = width
panel.height = height
panel.color = color
panel.visible = false
table.insert(UI[context].panel,panel)
return panel
end

-- [*creerUIText]
function creerUIText(x,y,color,pText,context)
-- @x           position x du text
-- @y           position y du text
-- @color       couleur du text
-- @pText        texte du button
-- @context     le context de l'UI


local text = {}
text.x = x
text.y = y
text.width = width
text.height = height
text.color = color
text.visible = false
text.text=pText
table.insert(UI[context].text,text)
return text
end

-- [*calculDistance]
function calculDistance(depart ,destination)
local a = {}
a.x =  destination.x - depart.x
a.y =  destination.y - depart.y
return a;
end


-- [*AStarPathfinding]
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
		-- [direction]
		--  1 : droite
		--  2 : gauche
		--  3 : haut
		--  4 : bas
		--  5 : droite-bas
		--  6 : gauche-bas
		--  7 : droite-haut
		--  8 : gauche-haut
		-- [/direction]
		local square_right = addSquareForAStarPathfinding(current_square,point,1)
		local square_left = addSquareForAStarPathfinding(current_square,point,2)
		local square_top = addSquareForAStarPathfinding(current_square,point,3)
		local square_bottom = addSquareForAStarPathfinding(current_square,point,4)
		local square_right_bottom = addSquareForAStarPathfinding(current_square,point,5)
		local square_left_bottom = addSquareForAStarPathfinding(current_square,point,6)
		local square_right_top = addSquareForAStarPathfinding(current_square,point,7)
		local square_left_top = addSquareForAStarPathfinding(current_square,point,8)

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
			elseif   (v.row == square_right_bottom.row and v.col == square_right_bottom.col) then
				square_right_bottom.isInOpenList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_left_bottom.row and v.col == square_left_bottom.col) then
				square_left_bottom.isInOpenList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_right_top.row and v.col == square_right_top.col) then
				square_right_top.isInOpenList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_left_top.row and v.col == square_left_top.col) then
				square_left_top.isInOpenList = true
				--Deja dans la liste ouverte
			end
		end

		-- Recherche si un noeud courant est dejà dans la liste fermee
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
			elseif   (v.row == square_right_bottom.row and v.col == square_right_bottom.col) then
				square_right_bottom.isInClosedList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_left_bottom.row and v.col == square_left_bottom.col) then
				square_left_bottom.isInClosedList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_right_top.row and v.col == square_right_top.col) then
				square_right_top.isInClosedList = true
				--Deja dans la liste ouverte
			elseif   (v.row == square_left_top.row and v.col == square_left_top.col) then
				square_left_top.isInClosedList = true
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
		if(square_right_bottom.isInOpenList ~= true and square_right_bottom.isInClosedList ~= true and square_right_bottom.isInNonWalkableTile ~= true) then table.insert(openList,square_right_bottom)
		end
		if(square_left_bottom.isInOpenList ~= true and square_left_bottom.isInClosedList ~= true and square_left_bottom.isInNonWalkableTile ~= true) then table.insert(openList,square_left_bottom)
		end
		if(square_right_top.isInOpenList ~= true and square_right_top.isInClosedList ~= true and square_right_top.isInNonWalkableTile ~= true) then table.insert(openList,square_right_top)
		end
		if(square_left_top.isInOpenList ~= true and square_left_top.isInClosedList ~= true and square_left_top.isInNonWalkableTile ~= true) then table.insert(openList,square_left_top)
		end


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


-- [*trackPath]
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



-- [*addSquareForAStarPathfinding]
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
	elseif(dir == 5) then
	square.col=pSquare.col +1
	square.row=pSquare.row + 1
	elseif(dir == 6) then
	square.col=pSquare.col +1
	square.row=pSquare.row - 1
	elseif(dir == 7) then
	square.col=pSquare.col -1
	square.row=pSquare.row + 1
	elseif(dir == 8) then
	square.col=pSquare.col -1
	square.row=pSquare.row -1
	end
	square.score_G=pSquare.score_G + 1
	local dx = math.max(square.col,point.x) - math.min(square.col,point.x)
	local dy = math.max(square.row,point.y) - math.min(square.row,point.y)
	square.score_H= dx  + dy
            square.score_Di = 1
	if(dir > 4) then
		--diagonal
	square.score_Di = 10.7
	end
	square.score_F= (square.score_G * square.score_H) + (square.score_Di - 2 * square.score_G) * (math.min(dx,dy) )
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


-- [*init]
function init()
	-- @i             index du sprite utilise
	-- @row           position x du sprite(en ligne)
	-- @col           position y du sprite(en colonne)
	-- [@pAlpha]      Couleur alpha utilise
	-- [@xOffset]     Position de decalage x
	-- [@yOffset]     Position de decalage y
	-- [@tag]         tag du sprite
	-- [@pColor]       color custom du sprite
	hero = creerSprite(12,1,1,nil,nil,nil,"hero")
	creerSprite(12,2,1,nil,nil,nil,"npc",character[1].color)
	creerSprite(12,3,1,nil,nil,nil,"npc",character[2].color)
	creerSprite(12,4,1,nil,nil,nil,"npc",character[3].color)
	creerSprite(12,5,1,nil,nil,nil,"npc",character[4].color)
	creerSprite(12,6,1,nil,nil,nil,"npc",character[5].color)
	creerSprite(12,7,1,nil,nil,nil,"npc",character[6].color)
	creerSprite(12,8,1,nil,nil,nil,"npc",character[7].color)
	creerSprite(12,9,1,nil,nil,nil,"npc",character[8].color)
	creerSprite(12,10,1,nil,nil,nil,"npc",character[9].color)

	-- @x              position x du rectangle
	-- @y              position y du rectangle
	-- @width          largeur du rectangle
	-- @height         hauteur du rectangle
	-- @color(objet)   couleur du rectangle
	-- [@text]         texte du button

	local button = creerUIButton(2,98,33,8,{9,0,15,15},"CHAR","baseMenu")
	button.state = "CHAR"
	button = creerUIButton(2,107,33,8,{9,0,15,15},"QUEST","baseMenu")
	button.state = "QUEST"
	button = creerUIButton(2,116,33,8,{9,0,15,15},"MAP","baseMenu")
	button.state = "MAP"
	button = creerUIButton(2,125,33,8,{9,0,15,15},"MENU","baseMenu")
	button.state = "MENU"

	button = creerUIButton(205,98,33,8,{9,0,15,15},"INV","baseMenu")
	button.state = "INV"
	button = creerUIButton(205,107,33,8,{9,0,15,15},"SPELLS","baseMenu")
	button.state = "SPELLS"

--<UI basemenu>
	--skill UI
	creerUIPanel(212,116,19,17,10,"baseMenu")
	creerUIPanel(213,117,17,15,2,"baseMenu")

	--item UI
	creerUIPanel(93,95,65,9,10,"baseMenu")

	--case
	creerUIPanel(94,96,7,7,2,"baseMenu")
	creerUIPanel(102,96,7,7,2,"baseMenu")
	creerUIPanel(110,96,7,7,2,"baseMenu")
	creerUIPanel(118,96,7,7,2,"baseMenu")
	creerUIPanel(126,96,7,7,2,"baseMenu")
	creerUIPanel(134,96,7,7,2,"baseMenu")
	creerUIPanel(142,96,7,7,2,"baseMenu")
	creerUIPanel(150,96,7,7,2,"baseMenu")

	--Fenetre interaction
	creerUIPanel(87,106,80,25,10,"baseMenu")
	creerUIPanel(88,107,78,23,2,"baseMenu")
	--<UI /basemenu>

	--<UI char>
	creerUIPanel(0,0,111,94,0,"char")
	creerUIPanel(0,0,110,93,3,"char")
	creerUIText(2,3,15,hero.data.name,"char")
	creerUIText(80,3,15,hero.data.class,"char")
	creerUIText(2,15,15,"Lv."..hero.data.lvl,"char")
	creerUIText(72,15,15,"xp."..hero.data.currentExp,"char")
	creerUIText(50,25,15,"next lvl."..hero.data.nextLevel,"char")
	creerUIText(5,38,15,"str     "..hero.data.strength,"char")
	creerUIText(42,38,8,"+ "..hero.data.strength_bonus,"char")

	creerUIText(86,38,15,"gold","char")
	creerUIText(5,48,15,"ma       "..hero.data.magic,"char")
	creerUIText(42,48,8,"+ "..hero.data.magic_bonus,"char")

	creerUIText(91,49,15,hero.data.gold,"char")
	creerUIText(5,58,15,"dex     "..hero.data.dexterity,"char")
	creerUIText(42,58,8,"+ "..hero.data.dexterity_bonus,"char")

	creerUIText(5,68,15,"vit      "..hero.data.vitality,"char")
	creerUIText(42,68,8,"+ "..hero.data.vitality_bonus,"char")
	-- @x                  position x du rectangle
	-- @y                  position y du rectangle
	-- @width              largeur du rectangle
	-- @height             hauteur du rectangle
	-- @color(table)       couleur du rectangle
	-- [@text]             texte du button
	-- @context            le context de l'UI
	creerUIText(5,78,15,"pt       "..hero.data.statsPoint,"char")
	button = creerUIButton(90,80,15,10,{9,0,15,15}," =>","char")
	button.state = "CHAR/1"
	--<UI /char>
	--<UI char/1>
	-- data = {
	-- 	name = "Jojoffrey",
	-- 	class="warrior",
	-- 	lvl = 1,
	-- 	hp = 50,
	-- 	mana = 20,
	-- 	strength = 10,
	-- 	magic = 10,
	-- 	dexterity = 10,
	-- 	vitality = 10,
	-- 	hp_bonus = 0,
	-- 	mana_bonus = 0,
	-- 	strength_bonus = 0,
	-- 	magic_bonus = 0,
	-- 	dexterity_bonus = 0,
	-- 	vitality_bonus = 0,
	-- 	gold = 0,
	-- 	armor_class = 0,
	-- 	hit = 1,
	-- 	damage = 0,
	-- 	resistMagic = 0,
	-- 	resistFire = 0,
	-- 	resistLightning = 0,
	-- 	currentExp = 0,
	-- 	nextLevel = 300,
	-- 	statsPoint = 0
	-- }
	creerUIPanel(0,0,111,94,0,"char/1")
	creerUIPanel(0,0,110,93,3,"char/1")
	creerUIText(2,3,15,"hp "..hero.data.current_hp.."/"..hero.data.hp,"char/1")
	creerUIText(60,3,15,"mana "..hero.data.current_mana.."/"..hero.data.mana,"char/1")
	creerUIText(2,20,15,"armor \nclass  "..hero.data.armor_class,"char/1")
	creerUIText(60,20,15,"hit % "..(hero.data.hit * 100),"char/1")
	creerUIText(60,30,15,"dmg "..hero.data.damage,"char/1")
	creerUIText(2,40,15,"resist ","char/1")
	creerUIText(2,50,15,"mag     "..(hero.data.resistMagic* 100).."%","char/1")
	creerUIText(2,60,15,"fire    "..(hero.data.resistFire* 100).."%","char/1")
	creerUIText(2,70,15,"light  "..(hero.data.resistLightning* 100).."%","char/1")

	button = creerUIButton(90,80,15,10,{9,0,15,15}," <=","char/1")
	button.state = "CHAR"
	--<UI /char/1>

	--<UI quest>
	creerUIPanel(0,0,111,94,0,"quest")
	creerUIPanel(0,0,110,93,3,"quest")
	creerUIPanel(6,4,98,84,0,"quest")
	button = creerUIButton(43,78,25,10,{0,0,15,13},"close","quest")
	button.state = "BASE_MENU"
	--<UI /quest>

	--<UI map>
	--<UI /map>

	--<UI menu>
	creerUIPanel(98,9,54,94,15,"menu")
	creerUIPanel(99,10,52,92,0,"menu")
	button = creerUIButton(113,22,17,15,{0,0,15,13},"save","menu")
	button = creerUIButton(113,42,15,15,{0,0,15,13},"load","menu")
	button = creerUIButton(113,62,22,15,{0,0,15,13},"option","menu")
	button = creerUIButton(113,82,17,15,{0,0,15,13},"title","menu")

	--<UI /menu>

	--<UI inv>
	creerUIPanel(145,0,95,94,0,"inv")
	creerUIPanel(146,0,95,93,3,"inv")
	creerUIPanel(146,54,95,39,10,"inv")

	creerUIPanel(185,0,19,19,10,"inv")
	creerUIPanel(186,1,8,8,0,"inv")
	creerUIPanel(195,1,8,8,0,"inv")
	creerUIPanel(195,10,8,8,0,"inv")
	creerUIPanel(186,10,8,8,0,"inv")


	creerUIPanel(185,21,19,19,10,"inv")
	creerUIPanel(186,22,8,8,0,"inv")
	creerUIPanel(195,22,8,8,0,"inv")
	creerUIPanel(195,31,8,8,0,"inv")
	creerUIPanel(186,31,8,8,0,"inv")

	creerUIPanel(163,21,19,19,10,"inv")
	creerUIPanel(164,22,8,8,0,"inv")
	creerUIPanel(173,22,8,8,0,"inv")
	creerUIPanel(173,31,8,8,0,"inv")
	creerUIPanel(164,31,8,8,0,"inv")

	creerUIPanel(207,21,19,19,10,"inv")
	creerUIPanel(208,22,8,8,0,"inv")
	creerUIPanel(217,22,8,8,0,"inv")
	creerUIPanel(217,31,8,8,0,"inv")
	creerUIPanel(208,31,8,8,0,"inv")

	creerUIPanel(172,42,10,10,10,"inv")
	creerUIPanel(173,43,8,8,0,"inv")

	creerUIPanel(207,42,10,10,10,"inv")
	creerUIPanel(208,43,8,8,0,"inv")

	creerUIPanel(207,8,10,10,10,"inv")
	creerUIPanel(208,9,8,8,0,"inv")

	for row = 1,4 do
		for col = 1,10 do
			creerUIPanel(148+(8* (col-1) +(col) ),55+(8*  (row-1) +(row) ),8,8,0,"inv")
		end
	end

	-- creerUIText(146,1,15,"inv","inv")
	--<UI /inv>

	--<UI spells>
	creerUIPanel(145,0,95,94,0,"spells")
	creerUIPanel(146,0,95,93,3,"spells")
	creerUIText(146,1,15,"spells","spells")
	--<UI /spells>

	-- @x           position x du text
	-- @y           position y du text
	-- @color       couleur du text
	-- @text        texte du button
	-- @context     le context de l'UI
	-- creerUIText()

	hero.tag = "hero"

end


init()


-- [*tic]
function TIC()
	-- local test = mapToScreen(hero.row,hero.col)
	x_map =52 -hero.x
	y_map = 16 -hero.y
	mx,my,md = mouse()
	x2=mx
	y2=my
	local point = screenToMap(mx, my)

	if  (md == true and path_already_loaded == false and y2 <=96 ) then
		if(UI.currentState =="BASE_MENU") then
			path_already_loaded = true
			helping_box.col = point.x
			helping_box.row = point.y
			-- define the pathFinding for the player
			hero.pathTrackObject = {}
			hero.currentAnimation = "move"
			AStarPathfinding( point ,hero);
			-- set the movment into motion for the player
		end

	end
	if (path_already_loaded == true) then
		path_already_loaded_counter = path_already_loaded_counter + 1
		if path_already_loaded_counter == 20 then
			path_already_loaded_counter = 0
			path_already_loaded = false
		end
	end

	if (md == true and button_click_already == false) then
		-- set the function ()
		local _uiState = "BASE_MENU"

		if(y2 >=96 and _uiState=="BASE_MENU") then
			for i=1,#UI.baseMenu.button do
				local button = UI.baseMenu.button[i]
				local x = button.x
				local y = button.y
				local w = button.width
				local h = button.height
				if( x2>=x and x2<=x+w and y2>=y and y2<=y+h) then
					   if(button.state ~= nil) then
						   changeUIbuttonState(button.state)
						   button_click_already = true
					   end
				end

			end
		end

		if(UI.currentState == "CHAR") then
			_uiState = "char"
		elseif (UI.currentState =="QUEST") then
			_uiState = "quest"
		elseif (UI.currentState =="INV") then
			_uiState = "inv"
		elseif (UI.currentState =="MENU") then
			_uiState = "menu"
		elseif (UI.currentState =="SPELLS") then
			_uiState = "spells"
		elseif (UI.currentState =="CHAR/1") then
			_uiState = "char/1"
		end
		if(_uiState ~= "BASE_MENU") then
			for i=1,#UI[_uiState].button do
				local button = UI[_uiState].button[i]
				local x = button.x
				local y = button.y
				local w = button.width
				local h = button.height
				if( x2>=x and x2<=x+w and y2>=y and y2<=y+h) then
					   if(button.state ~= nil) then
						   changeUIbuttonState(button.state)
						   button_click_already = true
					   end
				end

			end
		end

	end

	if (button_click_already == true) then
		button_click_already_counter = button_click_already_counter + 1
		if button_click_already_counter == 20 then
			button_click_already_counter = 0
			button_click_already = false
		end
	end

	hero.followPath()
	hero.animation.setMotion()
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


-- [*draw]
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

	-- for i,v in ipairs(path_tile) do
	--      setTile(16,v.row,v.col,0)
	-- end
	--
	-- for i,v in ipairs(path_tile_reverse) do
	--      setTile(4,v.row,v.col,0)
	-- end
	draw_helping_box()
	drawSprite()
end

-- [*drawSprite]
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
		outLineSprite(i, (x_map+ sprite.x )* SCALE + x_offset,( y_map+sprite.y ) * SCALE + y_offset,pAlpha)
		if(sprite.color ~= nil) then
			switchPal(12,sprite.color.skin)
			switchPal(4,sprite.color.shirt)
			switchPal(6,sprite.color.pant)
			if(sprite.color.alpha ~= sprite.pAlpha and sprite.color.alpha ~= nil) then
				switchPal(sprite.color.alpha,sprite.pAlpha)
			end

		end
		spr(i, (x_map+ sprite.x )* SCALE + x_offset,( y_map+sprite.y ) * SCALE + y_offset,pAlpha,SCALE)
		if(sprite.color ~= nil) then
			switchPal(12,12)
			switchPal(4,4)
			switchPal(6,6)

			if(sprite.color.alpha ~= sprite.pAlpha) then
				switchPal(11,11)
			end

		end
		-- spr(i, (x_map+8*col-8*row )* SCALE + x_offset,(y_map+4*col+4*row) * SCALE + y_offset,pAlpha,SCALE)

	end

end


-- [*draw_helping_box]
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


-- [*setTile]
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


-- [*mapToScreen]
function mapToScreen(row, col)
	local point = { x=0,y=0}
	point.x = (x_map + ( col - row ) * TILE_WIDTH_HALF ) * SCALE
	point.y = (y_map +( col + row) * TILE_HEIGHT_HALF ) * SCALE
	return point
end


-- [*screenToMap]
function screenToMap(mx, my)
	local point = {}
	point.x = math.floor( ( (mx-x_map *SCALE)/(TILE_WIDTH_HALF) +(my-y_map *SCALE)/TILE_HEIGHT_HALF ) /(2*SCALE)  ) -1
	point.y = math.floor( ( (my-y_map *SCALE)/(TILE_HEIGHT_HALF) -(mx-x_map*SCALE)/TILE_WIDTH_HALF ) /(2*SCALE)  )
	return point
end


-- [*OVR]
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

	-- baseMenu=
	-- char=
	-- menu=
	-- inv=
	-- skills=
	-- quest=
	-- BASE_MENU
	-- CHAR
	-- MAP
	-- MENU
	-- SPELL
	-- QUEST
	-- INV
	--<UI baseMenu>
	for i=1,#UI.baseMenu.panel do
		local panel = UI.baseMenu.panel[i]
		local x = panel.x
		local y = panel.y
		local w = panel.width
		local h = panel.height
		local c = panel.color
		rect(x,y,w,h,c)
	end

	for i=1,#UI.baseMenu.button do
		local button = UI.baseMenu.button[i]
		local x = button.x
		local y = button.y
		local w = button.width
		local h = button.height
		local cR = button.color
		local cT = button.colorText
		local text = button.text
		if( x2>=x and x2<=x+w and y2>=y and y2<=y+h) then
		   cR = button.colorHover
		   cT = button.colorTextHover
		end
		rect(x,y,w,h,cR)
		print(text,x+1,y+1,cT,false,1,true)
	end
	for i=1,#UI.baseMenu.text do
		local textUI = UI.baseMenu.text[i]
		local x = textUI.x
		local y = textUI.y
		local text = textUI.text
		print(text,x+1,y+1,15,false,1,true)
		-- rect(x,y,w,h,c)
	end
	--</UI baseMenu>

local _uiState = "BASE_MENU"
if(UI.currentState == "CHAR") then
	_uiState = "char"
elseif (UI.currentState =="QUEST") then
	_uiState = "quest"
elseif (UI.currentState =="INV") then
	_uiState = "inv"
elseif (UI.currentState =="MENU") then
	_uiState = "menu"
elseif (UI.currentState =="SPELLS") then
	_uiState = "spells"
elseif (UI.currentState =="CHAR/1") then
	_uiState = "char/1"
end
	if(_uiState ~= "BASE_MENU") then
		for i=1,#UI[_uiState].panel do
			local panel = UI[_uiState].panel[i]
			local x = panel.x
			local y = panel.y
			local w = panel.width
			local h = panel.height
			local c = panel.color
			rect(x,y,w,h,c)
		end
		for i=1,#UI[_uiState].button do
			local button = UI[_uiState].button[i]
			local x = button.x
			local y = button.y
			local w = button.width
			local h = button.height
			local cR = button.color
			local cT = button.colorText
			local text = button.text
			if( x2>=x and x2<=x+w and y2>=y and y2<=y+h) then
			   cR = button.colorHover
			   cT = button.colorTextHover
			end
			rect(x,y,w,h,cR)
			print(text,x+1,y+1,cT,false,1,true)
		end
		for i=1,#UI[_uiState].text do
			local textUI = UI[_uiState].text[i]
			local x = textUI.x
			local y = textUI.y
			local text = textUI.text
			local c = textUI.color
			print(text,x+1,y+1,c,false,1,true)
		end

	end
	if(UI.currentState == "MAP") then
		--<UI map>
		-- enter the function
		--</UI map>

	end



	-- spr(114,93,94,0)



	spr(100,x2,y2,5,SCALE);



end


-- [*switchPal]
function switchPal(c0,c1)
	if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i)end
	else poke4(0x3FF0*2+c0,c1)end
end

-- [*outLineSprite]
function outLineSprite(i,x,y,pAlpha)
	switchPal(0,15)
	switchPal(12,0)
	switchPal(4,0)
	switchPal(6,0)
	spr(i, x +1, y, 0, SCALE)
	spr(i, x -1, y, 0, SCALE)
	spr(i, x , y-1, 0, SCALE)
	switchPal(0,0)
	switchPal(12,12)
	switchPal(4,4)
	switchPal(6,6)

end
