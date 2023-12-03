require('BM_Utils')


Events.OnLoadedTileDefinitions.Add(function(manager)
    local sprites = {
        "location_military_generic_01_23",
        "location_military_generic_01_22",
        "location_military_generic_01_30",
        "location_military_generic_01_31",
    }

    for _, sprite in ipairs(sprites) do
        local props = manager:getSprite(sprite):getProperties()
        BM_Utils.setSpriteProperty(props, "ContainerCapacity", "100", false);
    end

    sprites = {
        "fixtures_windows_01_72",
        "fixtures_windows_01_73"
    }

    for _, sprite in ipairs(sprites) do
        local props = manager:getSprite(sprite):getProperties();
        BM_Utils.setSpriteProperty(props, "CanBreak", "", true);
        BM_Utils.setSpriteProperty(props, "PickUpTool", "Crowbar", false);
        BM_Utils.setSpriteProperty(props, "PlaceTool", "Hammer", false);
    end
end)