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
        -- regenerate those in order to make the map whole again
        for i = -7, 8 do
            surface.delete_chunk({i, 8})
            surface.delete_chunk({8, i})
        end
    end
end