require "common"

function InitLab(force)
    labName = LabName(force)
    if not game.surfaces[labName] then
        local surface = game.create_surface(labName, {
            default_enable_all_autoplace_controls = false,
            cliff_settings = {
                cliff_elevation_0 = 1024,
            },
        })
        --- thanks to factorissimo2 and mrvn on github https://gist.github.com/mrvn/745115395f7e08a716f04120753fb625/revisions#diff-2f29ee9c98c28d035046fb40285456da
        --- for the hint

        if remote.interfaces["RSO"] then -- RSO compatibility
            pcall(remote.call, "RSO", "ignoreSurface", labName)
         end
        ---
        surface.always_day = true
        surface.generate_with_lab_tiles = true

        EquipLab(surface, force)
    end

    if not game.forces[labName] then
        local new_force = game.create_force(labName)
        for _, entity in pairs(game.surfaces[labName].find_entities_filtered{force = force.name}) do
            entity.force = new_force
        end
    end
end

function ChunkLab(surface)
    for i = -LabRadius, LabRadius do
        for j = -LabRadius, LabRadius do
            surface.set_chunk_generated_status({i, j}, defines.chunk_generated_status.entities)
        end
    end
end

function TileLab(surface)
    tiles = {}
    for i = -LabRadius*32, LabRadius*32 - 1 do
        for j = -LabRadius*32, LabRadius*32 - 1 do
            if (i + j) % 2 == 0 then
                table.insert(tiles, {name = "lab-dark-1", position = {i, j}})
            else
                table.insert(tiles, {name = "lab-dark-2", position = {i, j}})
            end
        end
    end
    surface.set_tiles(tiles)
end


function EquipLab(surface, force)
    electricInterface = surface.create_entity {name = "electric-energy-interface", position = {0, 0}, force = force}
    electricInterface.minable = true

    infinityChest = surface.create_entity {name = "infinity-chest", position = {0, 1}, force = force}
    infinityChest.minable = true

	infinityPipe = surface.create_entity {name = "infinity-pipe", position = {-1, 1}, force = force}
    infinityPipe.minable = true

    mediumPole = surface.create_entity {name = "big-electric-pole", position = {0, -2}, force = force}
    mediumPole.minable = true
end

function ChartLabs()
    if settings.global["blueprint-lab-design-disable-fog"].value then
        local forces_checked = {}
        for _, player in pairs(game.players) do
            if IsLab(player.surface) and not forces_checked[player.force.name] then
                player.force.chart_all(player.surface)
                forces_checked[player.force.name] = true
            end
        end
    end
end

