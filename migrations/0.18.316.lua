require "scripts.common"

-- Edit generation settings on the lab to make it infinite
for _, surface in pairs(game.surfaces) do
    if IsLab(surface) then
        surface.map_gen_settings = {
            default_enable_all_autoplace_controls = false,
            cliff_settings = {
                cliff_elevation_0 = 1024,
            },
        }
        surface.generate_with_lab_tiles = true

        -- pre-infinite gen generated a partial border of empty chunks, so
        for i = -7, 8 do
            surface.delete_chunk({i, 7})
            surface.delete_chunk({8, i})
        end
        -- regenerate those in order to make the map whole again
        tiles = {}
		for i = -LabRadius*48, LabRadius*48 - 1 do
			for j = -LabRadius*48, LabRadius*48 - 1 do
				if (i + j) % 2 == 0 then
					table.insert(tiles, {name = "lab-dark-1", position = {i, j}})
				else
					table.insert(tiles, {name = "lab-dark-2", position = {i, j}})
				end
			end
		end
		surface.set_tiles(tiles)
    end
end

