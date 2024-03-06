require "common"
require "init-lab"

function OnLabButton(player_index)
    local player = game.players[player_index]
    local playerData = global[player_index]
    
    if playerData.inTheLab then
        ToTheWorld(player_index)
    elseif playerData.isUnlocked then
        InitLab(player.force)
        ToTheLab(player_index)
    end

    UpdateGui(player_index)
end

function BringBlueprint(player, cursor)
    if not IsBlueprintOrBook(cursor) then return end

    player.cursor_stack.set_stack(cursor)
end

function ToTheLab(player_index)
    local player = game.players[player_index]
    local playerData = global[player_index]

    if playerData.inTheLab then
        player.print "invalid operation, player already in the lab."
        return
    end
    
    if player.character == nil then
        player.print "No body, no lab. Them's the rules."
        return
    end

    player.character.destructible = false
    playerData.character = player.character
	player.set_controller({type = defines.controllers.god})
    player.teleport({0, 0}, LabName(player.force))

    BringBlueprint(player, playerData.character.cursor_stack)

	playerData.force = player.force.name
	player.force = LabName(player.force)
	SyncTechnologies(game.forces[playerData.force], game.forces[player.force.name])

    player.cheat_mode = true
	player.force.recipes["bpl-electric-energy-interface"].enabled = true
	player.force.recipes["bpl-infinity-chest"].enabled = true
	player.force.recipes["bpl-infinity-pipe"].enabled = true
	player.force.recipes["bpl-loader"].enabled = true
    player.force.recipes["bpl-fast-loader"].enabled = true
    player.force.recipes["bpl-express-loader"].enabled = true
    

    playerData.inTheLab = true
	
end

function ToTheWorld(player_index)
    local player = game.players[player_index]
    local playerData = global[player_index]

    if not playerData.inTheLab then
        player.print "invalid operation, player already in the world."
        return
    end
	
	if playerData.force ~= nil then
		player.force = playerData.force
		playerData.force = nil
	end

    player.cheat_mode = false
	player.force.recipes["bpl-electric-energy-interface"].enabled = false
	player.force.recipes["bpl-infinity-chest"].enabled = false
	player.force.recipes["bpl-infinity-pipe"].enabled = false
    player.force.recipes["bpl-loader"].enabled = false
    player.force.recipes["bpl-fast-loader"].enabled = false
    player.force.recipes["bpl-express-loader"].enabled = false


    DropBlueprints(player, player.get_main_inventory())
    local blueprint = ReturnBlueprintExport(player)

    player.teleport({0, 0}, playerData.character.surface)
	player.set_controller({type = defines.controllers.character, character = playerData.character})
    playerData.character = nil
    player.character.destructible = true

    ReturnBlueprintImport(player, blueprint)

    playerData.inTheLab = false
end

function SyncTechnologies(old_force, new_force)
    if settings.global["blueprint-lab-design-allow-all-technology"].value then
        new_force.research_all_technologies()
    else
        for tech, _ in pairs(game.technology_prototypes) do
            new_force.technologies[tech].researched = old_force.technologies[tech].researched
        end
    end
end

function DropBlueprints(player, inventory)
    for i = 1, #inventory do
        local stack = inventory[i]

        if IsBlueprintOrBook(stack) and stack.export_stack() ~= EmptyBlueprintString then
            player.surface.spill_item_stack({0, 4}, stack)
        end
    end
end

function ReturnBlueprintExport(player)
    if not IsBlueprintOrBook(player.cursor_stack) then return end

    local blueprint = player.cursor_stack.export_stack()
    if blueprint == EmptyBlueprintString then return end

    return blueprint
end

function ReturnBlueprintImport(player, blueprint)
    if not blueprint then return end

    if not player.clear_cursor() then
        player.surface.spill_item_stack(player.position, player.cursor_stack)
    end

    player.cursor_stack.import_stack(blueprint)
end

function WhereAmI(player_index)
    local player = game.players[player_index]
    local playerData = global[player_index]

    if playerData.inTheLab then
        player.print "in the lab"
    else
        player.print "in the world"
    end
end

function ClearLab(player_index)
    local player = game.players[player_index]
    local playerData = global[player_index]

    if not playerData.inTheLab then
        player.print "invalid operation, player not in the lab."
        return
    end

    for _, entity in pairs(player.surface.find_entities()) do
		DestroyEntity(entity, player_index)
    end
    for _, tile in pairs(player.surface.find_tiles_filtered {name = {"lab-dark-1", "lab-dark-2"}, invert = true}) do
        DestroyTile(tile, player.surface)
    end
	EquipLab(player.surface, player.force)
	--ChartLabs()
end
