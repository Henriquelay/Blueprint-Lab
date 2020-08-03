require "scripts.gui"
require "scripts.updates"
require "scripts.lab-effects"

function InitAllPlayers()
    for _, player in pairs(game.players) do
        InitPlayer(player.index)
    end
end

function InitIsUnlocked(player_index) do
    local is_technology_required = settings.startup["blueprint-lab-design-use-technology"].value
    local tech = settings.startup["blueprint-lab-design-unlock-technology"].value
    local playerData = global[player_index]
    if is_technology_required
            and game.players[player_index].force.technologies[tech] ~= nil
            and game.players[player_index].force.technologies[tech].enabled
            and not game.players[player_index].force.technologies[tech].researched
        then
            playerData.isUnlocked = false
        else
            playerData.isUnlocked = true
        end
    end
end

function InitPlayer(player_index)
    if global[player_index] then return end

    global[player_index] = {}
    InitIsUnlocked(player_index)
    CreateGui(player_index)
end

script.on_init(function()
    InitAllPlayers()
end)

script.on_configuration_changed(function(event)
    if event.mod_changes 
        and event.mod_changes["TheBlueprintLab_bud"]
        and event.mod_changes["TheBlueprintLab_bud"].old_version == "0.0.1" then
        ClearVersion001()
        InitAllPlayers()
    end
    
    for _, player in pairs(game.players) do
        InitIsUnlocked(player.index)
        CreateGui(player.index)
    end
end)

script.on_load(function()
    local is_technology_required = settings.startup["blueprint-lab-design-use-technology"].value
    local tech = settings.startup["blueprint-lab-design-unlock-technology"].value
    if is_technology_required then
        script.on_event(defines.events.on_research_finished, function (event)
            if event.research.name == tech then
                for _, player in pairs(event.research.force.players) do
                    local playerData = global[player.index]
                    playerData.isUnlocked = true
                    UpdateGui(player.index)
                end
            end
        end)
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    InitPlayer(event.player_index)
end)

--gui
script.on_event(defines.events.on_gui_click, OnGuiClick)
script.on_event("BPL_LabButtonHotkey", OnLabButtonHotkey)

--cheats
script.on_event(defines.events.on_marked_for_deconstruction, OnMarkedForDeconstruction)
script.on_event(defines.events.on_built_entity, OnBuiltEntity)