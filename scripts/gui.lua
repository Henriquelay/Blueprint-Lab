require "logic"
require "init-lab"

function CreateGui(player_index)
    local player = game.players[player_index]
    local playerData = global[player_index]
    if player.gui.left["BPL_Flow"] == nil then
        player.gui.left.add {type = "flow", name = "BPL_Flow"}
    end
    playerData.flow = player.gui.left["BPL_Flow"]
    playerData.flow.clear()
    playerData.button = playerData.flow.add {type = "button", name = "BPL_LabButton", 
        caption = {"bpl.LabButton"}, tooltip = {"bpl.LabButtonTooltip"}}
    playerData.clearButton = playerData.flow.add {type = "button", name = "BPL_ClearButton", 
        caption = {"bpl.ClearButton"}, tooltip = {"bpl.ClearButtonTooltip"}}
    
    UpdateGui(player_index)
end

function UpdateGui(player_index)
    local playerData = global[player_index]

    if playerData.inTheLab then
        playerData.button.caption = {"bpl.LabButtonReturn"}
        --playerData.flow.visible = true
        playerData.button.visible = true
        playerData.clearButton.visible = true
    else
        if playerData.isUnlocked then
            playerData.button.caption = {"bpl.LabButton"}
            --playerData.flow.visible = true
            playerData.button.visible = true
            playerData.clearButton.visible = false
        else
            --playerData.flow.visible = false
            playerData.button.visible = false
            playerData.clearButton.visible = false
        end
    end
end

function OnGuiClick(event)
    if event.element.name == "BPL_LabButton" then
        OnLabButton(event.player_index)
    elseif event.element.name == "BPL_StateButton" then
        WhereAmI(event.player_index)
    elseif event.element.name == "BPL_ClearButton" then
        ClearLab(event.player_index)
    end
end

function OnLabButtonHotkey(event)
    OnLabButton(event.player_index)
end