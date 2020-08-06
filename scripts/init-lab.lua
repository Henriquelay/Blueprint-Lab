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