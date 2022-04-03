require "scripts.gui"
require "scripts.updates"
require "scripts.lab-effects"

function InitAllPlayers()
    for _, player in pairs(game.players) do
        ClearVersion001()
        InitPlayer(player.index)
       -- player.print "loading lab."
    end
end

function InitPlayer(player_index)
    if global[player_index] then return end

    global[player_index] = {}
    --InitIsUnlocked(player_index)
    CreateGui(player_index)  
end

script.on_init(function()
    InitAllPlayers()
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