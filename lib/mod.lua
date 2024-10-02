local mod = require("core/mods")
local util = require("lib/util")

-- TODO: user assignable values
local assigns = {
    ["param"] = {
        [1] = {
            id = "channel_1_velocity_range",
            value = 0,
        },
    },
    ["in"] = {
        [1] = {
            id = "channel_1_velocity_min",
            value = 0,
        },
    },
}

mod.hook.register("script_pre_init", "txiii init", function()
    crow.ii.txi.event = function(event, value)
        if assigns[event.name] == nil or assigns[event.name][event.arg] == nil then
            return
        end

        local param_id = assigns[event.name][event.arg].id
        local range = params:get_range(param_id)
        local in_min = 0
        local in_max = event.name == "in" and 5 or 10
        local clamped_value = util.linlin(in_min, in_max, range[1], range[2], value)
        params:set(param_id, clamped_value)
        assigns[event.name][event.arg].value = value
    end

    clock.run(function()
        while true do
            for i = 1, 4 do
                crow.ii.txi.get("param", i)
                clock.sleep(0.05)
                crow.ii.txi.get("in", i)
                clock.sleep(0.05)
            end
        end
    end)
end)
