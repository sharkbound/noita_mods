-- all functions below are optional and can be left out


-- function OnModPreInit()
-- 	print("Mod - OnModPreInit()") -- First this is called for all mods
-- end

-- function OnModInit()
-- 	print("Mod - OnModInit()") -- After that this is called for all mods
-- end

-- function OnModPostInit()
-- 	print("Mod - OnModPostInit()") -- Then this is called for all mods
-- end

dofile_once("data/scripts/perks/perk_list.lua")
-- dofile_once("mods/startingkit/files/wands.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

WAND_INV = "inventory_quick"
SPELL_INV = "inventory_full"

function add_perk_to_player(player_entity, perk_id)
    local perk_data = get_perk_with_id(perk_list, perk_id)
    GameAddFlagRun(get_perk_picked_flag_name(perk_id))
    if perk_data.game_effect ~= nil then
        local e = GetGameEffectLoadTo(player_entity, perk_data.game_effect, true)
        if e ~= nil then
            ComponentSetValue(e, "frames", "-1")
        end
    end
    if perk_data.func ~= nil then
        perk_data.func(nil, player_entity, nil)
    end
    local ui = EntityCreateNew("")
    EntityAddComponent(ui, "UIIconComponent",
    {
        name = perk_data.ui_name,
        description = perk_data.ui_description,
        icon_sprite_file = perk_data.ui_icon
    })
    EntityAddChild(player_entity, ui)
end

function get_player_inventory(player_entity, inv_id)
    local player_child_entities = EntityGetAllChildren(player_entity)
	if (player_child_entities ~= nil) then
		for i,child_entity in ipairs(player_child_entities) do
			local child_entity_name = EntityGetName(child_entity)
			if (child_entity_name == inv_id) then
				inventory = child_entity
			end
		end
	end
    return inventory
end

function get_inventory_items(inventory)
    if (inventory ~= nil) then
		local inventory_items = EntityGetAllChildren(inventory)
        return inventory_items
    end
    return nil
		    
end

function add_wands_to_player(player_entity) 
    local inv = get_player_inventory(player_entity, WAND_INV)
    local x, y = EntityGetTransform(player_entity)

    if ( inv ~= nil ) then
		local inventory_items = EntityGetAllChildren( inventory )
		
		-- remove default items
        local removed = 0
		if inventory_items ~= nil then
			for i,item_entity in ipairs( inventory_items ) do
                print(item_entity)
				GameKillInventoryItem( player_entity, item_entity )
                removed = removed + 1
                if removed == 5 then
                    break
                end
			end
		end
    end

    local main_wand = EntityLoad("mods/startingkit/files/opwand.xml", x, y)
    AddGunAction(main_wand, "LIGHT_BULLET")
    EntityAddChild(inv, main_wand)

    local explosive_wand = EntityLoad("mods/startingkit/files/opwand.xml", x, y)
    AddGunAction(explosive_wand, "ROCKET")
    AddGunAction(explosive_wand, "DYNAMITE")
    AddGunAction(explosive_wand, "CHAINSAW")
    AddGunAction(explosive_wand, "DIGGER")
    AddGunAction(explosive_wand, "POWERDIGGER")
    EntityAddChild(inv, explosive_wand)  
    
    local empty_wand = EntityLoad("mods/startingkit/files/opwand.xml", x, y)
    EntityAddChild(inv, empty_wand)
    
    local empty_wand = EntityLoad("mods/startingkit/files/opwand.xml", x, y)
    EntityAddChild(inv, empty_wand)
end

function OnPlayerSpawned(player_entity) -- This runs when player entity has been created
	local init_check_flag = "startingkit_done"
	if GameHasFlagRun(init_check_flag) then
		return
	end
	GameAddFlagRun(init_check_flag)

	add_perk_to_player(player_entity, "BLEED_SLIME")
	add_perk_to_player(player_entity, "HEARTS_MORE_EXTRA_HP")
	add_perk_to_player(player_entity, "BREATH_UNDERWATER")
	add_perk_to_player(player_entity, "NO_MORE_KNOCKBACK")
	add_perk_to_player(player_entity, "PROTECTION_FIRE")
	add_perk_to_player(player_entity, "NO_MORE_SHUFFLE")
	add_perk_to_player(player_entity, "EXTRA_PERK")
	add_perk_to_player(player_entity, "EXTRA_SHOP_ITEM")
	add_perk_to_player(player_entity, "PEACE_WITH_GODS")
	add_perk_to_player(player_entity, "HOVER_BOOST")
	add_perk_to_player(player_entity, "HOVER_BOOST")

    add_wands_to_player(player_entity)
end

-- function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
-- 	GamePrint("OnWorldInitialized() " .. tostring(GameGetFrameNum()))
-- end

-- function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
-- 	GamePrint("Pre-update hook " .. tostring(GameGetFrameNum()))
-- end

-- function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
-- 	GamePrint("Post-update hook " .. tostring(GameGetFrameNum()))
-- end

-- function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
-- 	local x = ProceduralRandom(0,0)
-- 	print("===================================== random " .. tostring(x))
-- end


-- This code runs when all mods' filesystems are registered
-- ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/example/files/actions.lua") -- Basically dofile("mods/example/files/actions.lua") will appear at the end of gun_actions.lua
-- ModMagicNumbersFileAdd("mods/example/files/magic_numbers.xml") -- Will override some magic numbers using the specified file
-- ModRegisterAudioEventMappings("mods/example/files/audio_events.txt") -- Use this to register custom fmod events. Event mapping files can be generated via File -> Export GUIDs in FMOD Studio.
-- ModMaterialsFileAdd("mods/example/files/materials_rainbow.xml") -- Adds a new 'rainbow' material to materials
-- ModLuaFileAppend("data/scripts/items/potion.lua", "mods/example/files/potion_appends.lua")

--print("Example mod init done")