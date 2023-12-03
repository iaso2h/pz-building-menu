ISFridge = ISBuildingObject:derive("ISFridge");

--************************************************************************--
--** ISFridge:new
--**
--************************************************************************--
function ISFridge:create(x, y, z, north, sprite)
	local cell = getWorld():getCell();
	self.sq = cell:getGridSquare(x, y, z);
	self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self);
	
    -- local _freezerInv = ItemContainer.new()
    -- _freezerInv:setType('freezer')
    -- _freezerInv:setCapacity(20)
	-- _freezerInv:removeAllItems()
    -- _freezerInv:setIsDevice(true)
    -- _freezerInv:setParent(self.javaObject)
    -- self.javaObject:addSecondaryContainer(_freezerInv)

	self.javaObject:createContainersFromSpriteProperties()

	for i=1,self.javaObject:getContainerCount() do
		self.javaObject:getContainerByIndex(i-1):setExplored(true)
	end

    buildUtil.setInfo(self.javaObject, self);
	buildUtil.consumeMaterial(self);
	-- the wooden wall have 200 base health + 100 per carpentry lvl
	self.javaObject:setMaxHealth(self:getHealth());
	self.javaObject:setHealth(self.javaObject:getMaxHealth());
	-- the sound that will be played when our fridge will be broken
	self.javaObject:setBreakSound("BreakObject");

	local sharedSprite = getSprite(self:getSprite())
	if self.sq and sharedSprite and sharedSprite:getProperties():Is("IsStackable") then
		local props = ISMoveableSpriteProps.new(sharedSprite)
		self.javaObject:setRenderYOffset(props:getTotalTableHeight(self.sq))
	end

	-- add the item to the ground
    self.sq:AddSpecialObject(self.javaObject);
	self.javaObject:transmitCompleteItemToServer();
end

function ISFridge:new(player, name, sprite, northSprite)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o:init();
	o:setSprite(sprite);
	o:setNorthSprite(northSprite);
    o.player = player
	o.isContainer = true;
	o.blockAllTheSquare = true;
	o.name = name;
	o.canBarricade = false;
	o.dismantable = true;
	o.canBeAlwaysPlaced = true;
    o.canBeLockedByPadlock = true;
	o.buildLow = false;
	return o;
end

-- return the health of the new container, it's 300 + 100 per carpentry lvl
function ISFridge:getHealth()
	return 300 + buildUtil.getWoodHealth(self);
end

function ISFridge:isValid(square)
    if buildUtil.stairIsBlockingPlacement( square, true ) then return false; end
	if not self:haveMaterial(square) then return false end
	local sharedSprite = getSprite(self:getSprite())
	if square and sharedSprite and sharedSprite:getProperties():Is("IsStackable") then
		local props = ISMoveableSpriteProps.new(sharedSprite)
		return props:canPlaceMoveable("bogus", square, nil)
	end
	return ISBuildingObject.isValid(self, square);
end

function ISFridge:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)
end
