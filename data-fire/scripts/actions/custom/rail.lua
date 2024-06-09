--Script by mock the bear
--Config
local SPEED = 1
local PLAYERSPEED = 600
--End
local RAILS = {7121, 7122, 7123, 7124, 7125, 7126, 7127, 7128, 7129, 7130} --Thxy rails itemid by nord :P
local CART = {[0] = 7132, [2] = 7132, [3] =7131, [1] =7131}
local CONFIG = {
		[7121] = {NORTH, SOUTH},
		[7122] = {EAST, WEST},
		[7123] = {EAST, SOUTH},
		[7124] = {WEST, SOUTH},
		[7125] = {EAST, NORTH},
		[7126] = {WEST, NORTH},
		[7127] = 0,[7128] = 0,
		[7129] = 0,[7130] = 0,
		[152] = {NORTH, SOUTH},	 --modificado por  Piporealino Xtibia
		[153] = {SOUTH, NORTH},		
		[154] = {EAST, WEST},  
		[155] = {WEST, EAST},
		--Random
}
local reverse = {[0] = 2, 3, 0, 1} -- All that table was made by nord.
local function moveTrain(cid, frompos, direc)
		local tab
		if not isPlayer(cid) then
				return
		end
		local pos = getCreaturePosition(cid)
		local rar = findRail(pos)
		if not rar then
				doPlayerSetNoMove(cid, false)
				doRemoveCondition(cid, CONDITION_OUTFIT)
				doChangeSpeed(cid, -PLAYERSPEED)
				doMoveCreature(cid, direc)
		else
				tab = CONFIG[rar]
				if tab and type(tab) == 'table' then
						direc =  tab[tab[1] == reverse[direc] and 2 or 1] -- by nord here
				end
				doSetItemOutfit(cid, CART[direc], -1)
				doMoveCreature(cid, direc)
				addEvent(moveTrain, SPEED, cid, pos,direc)
		end
end
function findRail(p)
		local p_ = {x=p.x, y=p.y, z=p.z}
		for i=0,10 do
				p_.stackpos = i
				local t = getTileThingByPos(p_)
				if isInArray(RAILS, t.itemid) then
						return t.itemid,t.uid
				end
		end
end

local rails = Action()
function rails.onUse(player, item, frompos) --Script by mock the bear
		if getCreatureCondition(player, CONDITION_OUTFIT) == true or (item.actionid < 500 and item.actionid > 503) or getCreatureCondition(player, CONDITION_INFIGHT)  == true then
				return false
		end
		if item.actionid < 500 and player:getStorageValue(Storage.WagonTicket) < os.time() then
		player:say("Purchase a weekly ticket from Gewen, Lokur in the post office, The Lukosch brothers or from Brodrosch on the steamboat.", TALKTYPE_MONSTER_SAY)
		return true
		end
		doTeleportThing(player, frompos, false)
		player:addAchievementProgress("Rollercoaster", 100)
		mayNotMove(player, true)
		doChangeSpeed(player, PLAYERSPEED)
		addEvent(moveTrain, SPEED, player, frompos, item.actionid-500)
		return true

end

for index, value in pairs(CART) do
	rails:aid(index)
end

rails:register()
